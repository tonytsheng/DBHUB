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
#from elasticsearch import Elasticsearch, helpers
from opensearchpy import OpenSearch, RequestsHttpConnection, helpers
from requests_aws4auth import AWS4Auth
import pandas as pd
from opensearchpy import helpers
import json
from openai import OpenAI
from langchain.embeddings import BedrockEmbeddings
from langchain.vectorstores import OpenSearchVectorSearch
from langchain.chains import RetrievalQA
from langchain.prompts import PromptTemplate
from langchain.llms.bedrock import Bedrock

#wikipedia_dataframe = pd.read_csv("data/vector_database_wikipedia_articles_embedded.csv")
#wikipedia_dataframe.head()

index_name = "openai_wikipedia_index"
bedrock_model_id="anthropic.claude-v2"

def get_bedrock_client(region):
    bedrock_client = boto3.client("bedrock", region)
    return bedrock_client


def create_langchain_vector_embedding_using_bedrock(bedrock_client, bedrock_embedding_model_id):
    bedrock_embeddings_client = BedrockEmbeddings(
        client=bedrock_client,
        model_id=bedrock_embedding_model_id)
    return bedrock_embeddings_client

def dataframe_to_bulk_actions(df):
    for index, row in df.iterrows():
        yield {
            "_index": index_name,
            "_id": row['id'],
            "_source": {
                'url' : row["url"],
                'title' : row["title"],
                'text' : row["text"],
                'title_vector' : json.loads(row["title_vector"]),
                'content_vector' : json.loads(row["content_vector"]),
                'vector_id' : row["vector_id"]
            }
        }


client = boto3.client('opensearch')
host="search-os100-r2nzbuvapidbpw36nzem54ma7q.us-east-2.es.amazonaws.com" # no trailing slash at end of host field
service = 'es'
credentials = boto3.Session().get_credentials()
region='us-east-2'
awsauth = AWS4Auth(credentials.access_key, credentials.secret_key,
                   region, service, session_token=credentials.token)

client = OpenSearch(
    hosts = [{'host': host, 'port': 443}],
    http_auth = awsauth,
    use_ssl = True,
    verify_certs = True,
    connection_class = RequestsHttpConnection
)


res = client.search(index=index_name, body={
    "_source": {
        "excludes": ["title_vector", "content_vector"]
    },
    "query": {
        "match": {
            "text": {
                "query": "Pizza"
            }
        }
    }
})

print(res["hits"]["hits"][0]["_source"]["text"])


#bedrock_client = get_bedrock_client(region)
#bedrock_llm = create_bedrock_llm(bedrock_client, bedrock_model_id)
