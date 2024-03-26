import boto3
import json
import os
from langchain.text_splitter import RecursiveCharacterTextSplitter
from langchain.llms.bedrock import Bedrock
from tqdm.autonotebook import tqdm
from langchain.embeddings.openai import OpenAIEmbeddings
import numpy as np
import numpy as np
from langchain.text_splitter import CharacterTextSplitter, RecursiveCharacterTextSplitter
from urllib.request import urlretrieve
from langchain_community.document_loaders import PyPDFLoader 
from langchain_community.document_loaders import PyPDFDirectoryLoader
from langchain_community.vectorstores import Pinecone
from langchain_community.vectorstores import Chroma
from langchain_community.embeddings import BedrockEmbeddings
from langchain.chains.question_answering import load_qa_chain

bedrock_runtime = boto3.client(
    service_name = "bedrock-runtime",
    region_name = "us-east-1"
)

bedrock = boto3.client(
    service_name = "bedrock",
    region_name = "us-east-1"
)

modelId = 'anthropic.claude-v2'
accept = 'application/json'
contentType = 'application/json'


os.makedirs("data", exist_ok=True)
#files = [
#    "https://incometaxindia.gov.in/Supporting%20Files/ITR2021/Instructions_ITR1_AY2021_22.pdf",
#    "https://incometaxindia.gov.in/Supporting%20Files/ITR2021/Instructions_ITR2_AY2021_22.pdf"
#]
#for url in files:
#    file_path = os.path.join("data", url.rpartition("/")[2])
#    urlretrieve(url, file_path)

loader = PyPDFDirectoryLoader("./materials/")

documents = loader.load()
text_splitter = RecursiveCharacterTextSplitter(
    # Set a really small chunk size, just to show.
    chunk_size=2000,
    chunk_overlap=0,
)
docs = text_splitter.split_documents(documents)

#os.environ["PINECONE_API_KEY"] = "b39618af-f69d-42d1-a2c4-3863d0068927"
#os.environ["PINECONE_API_ENV"] = "YOUR_PINECONE_ENV"

#Pinecone.init(
#    api_key = os.environ.get('PINECONE_API_KEY'),
#    environment = os.environ.get('PINECONE_API_ENV')
#)

index_name = "itrsearchdx"

llm = Bedrock(
    model_id=modelId,
    client=bedrock_runtime
)
bedrock_embeddings = BedrockEmbeddings(client=bedrock_runtime)

#if index_name in pinecone.list_indexes():
#    Pinecone.delete_index(index_name)

#pinecone.create_index(name=index_name, dimension=1536, metric="dotproduct")
# wait for index to finish initialization
#while not pinecone.describe_index(index_name).status["ready"]:
#    time.sleep(1)

#docsearch = Pinecone.from_texts(
#    [t.page_content for t in docs],
#    bedrock_embeddings,
#    index_name = index_name
#)


chain = load_qa_chain(llm, chain_type = "stuff")
query = "Who is eligible to use this return form?"
print ("::: Query = " + query)
docs = docsearch.similarity_search(query)
chain.run(input_documents = docs, question = query)

