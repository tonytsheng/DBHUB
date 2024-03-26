import os
import boto3
from langchain.chains import RetrievalQA
from langchain_community.document_loaders import TextLoader
from langchain_community.document_loaders import PyPDFLoader
from langchain.indexes import VectorstoreIndexCreator
from langchain.text_splitter import CharacterTextSplitter
from langchain_community.embeddings import OpenAIEmbeddings
from langchain_community.vectorstores import Chroma
from langchain_openai import OpenAI
from langchain.chains.question_answering import load_qa_chain
from langchain_community.embeddings import BedrockEmbeddings
import os 
os.environ["OPENAI_API_KEY"] = ""

# load document
#loader = PyPDFLoader("materials/example.pdf")
#documents = loader.load()

### For multiple documents
# loaders = [....]
# documents = []
# for loader in loaders:
#     documents.extend(loader.load())

index_name = "openai_wikipedia_index"
bedrock_model_id="anthropic.claude-v2"
host="search-os100-r2nzbuvapidbpw36nzem54ma7q.us-east-2.es.amazonaws.com" # no trailing slash at end of host field

def create_opensearch_vector_search_client(index_name, bedrock_embeddings_client, opensearch_endpoint, _is_aoss=False):
    docsearch = OpenSearchVectorSearch(
        index_name=index_name,
        embedding_function=bedrock_embeddings_client,
        opensearch_url=f"https://{opensearch_endpoint}",
#        http_auth=(index_name, opensearch_password),
        is_aoss=_is_aoss
    )
    return docsearch

def get_bedrock_client(region):
    bedrock_client = boto3.client("bedrock-runtime", region)
    return bedrock_client

def create_langchain_vector_embedding_using_bedrock(bedrock_client, bedrock_embedding_model_id):
    bedrock_embeddings_client = BedrockEmbeddings(
        client=bedrock_client,
        model_id=bedrock_embedding_model_id)
    return bedrock_embeddings_client

bedrock_client = boto3.client('bedrock', 'us-east-1')
print ("::: bedrock_client = " + str(bedrock_client))
bedrock_llm = create_langchain_vector_embedding_using_bedrock(bedrock_client, bedrock_model_id)
print ("::: bedrock_llm = " + str(bedrock_llm))

#chain = load_qa_chain(llm=OpenAI(), chain_type="map_reduce")
chain = load_qa_chain(llm=bedrock_llm, chain_type="stuff")
query = "what is the total number of AI publications?"
chain.run(input_documents=documents, question=query)
