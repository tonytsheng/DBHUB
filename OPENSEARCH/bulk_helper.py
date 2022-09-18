import boto3
from opensearchpy import OpenSearch, RequestsHttpConnection
import json
from requests_aws4auth import AWS4Auth

host = 'vpc-opens-100-qxbfasmzqxudspvm2sn3vcwv6a.us-east-2.es.amazonaws.com' # For example, my-test-domain.us-west-2.es.amazonaws.com
region = 'us-east-2' # For example, us-west-2
service = 'es'
#profile='ec2'

bulk_file = open('/home/ec2-user/data/sample-calls.bulk', 'r').read()

#boto3.setup_default_session(profile_name='ec2')
credentials = boto3.Session().get_credentials()
print (credentials)
awsauth = AWS4Auth(credentials.access_key, credentials.secret_key, region, service, session_token=credentials.token)

search = OpenSearch(
    hosts = [{'host': host, 'port': 443}],
    http_auth = awsauth,
    use_ssl = True,
    verify_certs = True,
    connection_class = RequestsHttpConnection
)

response = search.bulk(bulk_file)
print(json.dumps(response, indent=2, sort_keys=True))
