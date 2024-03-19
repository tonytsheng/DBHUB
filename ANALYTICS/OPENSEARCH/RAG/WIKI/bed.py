import boto3
import pprint
from botocore.client import Config
import json

region='us-east-1'
pp = pprint.PrettyPrinter(indent=2)
session = boto3.session.Session()
region = session.region_name
bedrock_config = Config(connect_timeout=120, read_timeout=120, retries={'max_attempts': 0})
bedrock_client = boto3.client('bedrock-runtime', region_name = region)
bedrock_agent_client = boto3.client("bedrock-runtime",
                              config=bedrock_config, region_name = region)
print(region)
