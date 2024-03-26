import logging
import traceback
import sys
import boto3
from datetime import datetime
from datetime import date
from random import choice
import random
import string
import time
import json
import csv
from elasticsearch import Elasticsearch, helpers
from opensearchpy import OpenSearch, RequestsHttpConnection, helpers
from requests_aws4auth import AWS4Auth
import pandas as pd
from opensearchpy import helpers
import json
from openai import OpenAI
from botocore.client import Config
from langchain_community.embeddings import BedrockEmbeddings
from langchain.chains import RetrievalQA
from langchain.prompts import PromptTemplate
#from langchain.vectorstores import OpenSearchVectorSearch
from pydantic import BaseModel
from langchain_community.vectorstores import OpenSearchVectorSearch

index_name = "openai_wikipedia_index"
bedrock_model_id="anthropic.claude-v2"

def get_bedrock_client(region):
    bedrock_client = boto3.client("bedrock-runtime", "us-east-1")
    return bedrock_client

def create_langchain_vector_embedding_using_bedrock(bedrock_client, bedrock_embedding_model_id):
    bedrock_embeddings_client = BedrockEmbeddings(
        client=bedrock_client,
        model_id=bedrock_embedding_model_id)
    return bedrock_embeddings_client

def create_opensearch_vector_search_client(index_name, bedrock_embeddings_client, opensearch_endpoint, _is_aoss=False):
    docsearch = OpenSearchVectorSearch(
        index_name=index_name,
        embedding_function=bedrock_embeddings_client,
        opensearch_url=f"https://{opensearch_endpoint}",
#        http_auth=(index_name, opensearch_password),
        is_aoss=_is_aoss
    )
    return docsearch


client = boto3.client('opensearch')
host="search-os100-r2nzbuvapidbpw36nzem54ma7q.us-east-2.es.amazonaws.com" # no trailing slash at end of host field
service = 'es'
credentials = boto3.Session().get_credentials()
awsauth = AWS4Auth(credentials.access_key, credentials.secret_key,
                   "ue-east-2", service, session_token=credentials.token)

bedrock_client = boto3.client('bedrock', 'us-east-1')
print ("::: bedrock_client = " + str(bedrock_client))
bedrock_llm = create_langchain_vector_embedding_using_bedrock(bedrock_client, bedrock_model_id)
print ("::: bedrock_llm: " + str(bedrock_llm))

prompt_template = """Use the following pieces of context to answer the question at the end. If you don't know the answer, just say that you don't know, don't try to make up an answer. don't include harmful content

{context}

Question: {question}
Answer:"""
PROMPT = PromptTemplate(
    template=prompt_template, input_variables=["context", "question"]
)
print ("::: Prompt = " + str(PROMPT))

bedrock_embedding_model_id="amazon.titan-embed-text-v1"
bedrock_embeddings_client = create_langchain_vector_embedding_using_bedrock(bedrock_client, bedrock_embedding_model_id)
opensearch_endpoint="search-os100-r2nzbuvapidbpw36nzem54ma7q.us-east-2.es.amazonaws.com"
opensearch_vector_search_client = create_opensearch_vector_search_client(index_name, bedrock_embeddings_client, opensearch_endpoint)

print (opensearch_vector_search_client)
print ("before qa")
qa = RetrievalQA.from_chain_type(bedrock_llm,
                                     chain_type="stuff",
                                     retriever=opensearch_vector_search_client.as_retriever(),
                                     return_source_documents=True,
                                     chain_type_kwargs={"prompt": PROMPT, "verbose": True},
                                     verbose=True)

response = qa(question, return_only_outputs=False)

source_documents = response.get('source_documents')
for d in source_documents:
    print("With the following similar content from OpenSearch:\n{d.page_content}\n")
    print("Text: {d.metadata['text']}")
    print("The answer from Bedrock {bedrock_model_id} is: {response.get('result')}")


