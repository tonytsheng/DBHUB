from requests_aws4auth import AWS4Auth
from opensearchpy import OpenSearch, RequestsHttpConnection
import boto3
from langchain.embeddings.openai import OpenAIEmbeddings
from langchain.vectorstores import OpenSearchVectorSearch


region = 'us-east-2'
service = 'es'
credentials = boto3.Session().get_credentials()
awsauth = AWS4Auth(credentials.access_key, credentials.secret_key, region, service, session_token=credentials.token)


vector = OpenSearch(
   hosts = [{'host': 'search-os100-r2nzbuvapidbpw36nzem54ma7q.us-east-2.es.amazonaws.com', 'port': 443}],
   http_auth = awsauth,
   use_ssl = True,
   verify_certs = True,
   http_compress = True,
   connection_class = RequestsHttpConnection
)

index_body = {
  'settings': {
    "index.knn": True
  },
  "mappings": {
    "properties": {
      "osha_vector": {
        "type": "knn_vector",
        "dimension": 1536,
        "method": {
          "engine": "faiss",
          "name": "hnsw",
          "space_type": "l2"
        }
      }
    }
  }
}

#response = vector.indices.create('aoss-index', body=index_body)
#print ("create index: " + response)

embeddings = OpenAIEmbeddings()

vector = OpenSearchVectorSearch(
  embedding_function = embeddings,
  index_name = 'aoss-index',
  http_auth = awsauth,
  use_ssl = True,
  verify_certs = True,
  http_compress = True, # enables gzip compression for request bodies
  connection_class = RequestsHttpConnection,
  opensearch_url="https://search-os100-r2nzbuvapidbpw36nzem54ma7q.us-east-2.es.amazonaws.com"
)

print (str(vector))
