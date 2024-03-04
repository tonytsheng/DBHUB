## will run until user interrupts
## multi database engine driver used to illustrate
## connection retry logic 
## use this when demonstrating failover
## currently only oracle engines

## run : python3 driver.py

#!/usr/bin/env python3
#----------------------------------------------------------------------------
# Created By  : Tony Sheng ttsheng@amazon.com
# Created Date: 2023-12-21
# version ='1.0'
# ---------------------------------------------------------------------------
#
#     demonstrate database reboot and reconnect logic
#
# ---------------------------------------------------------------------------
#
# To run:
#    $ python3 driver.y $SECRET_ARN
#
# ---------------------------------------------------------------------------
#
# History
# 2023-12-20 - Version 1.0
# ---------------------------------------------------------------------------
#
# ToDo

## add more engines


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
from tqdm.contrib.concurrent import process_map
#from multiprocessing import cpu_count
import pandas as pd

#SECRET=(sys.argv[1])

def get_secret():
    secret_name = SECRET
    region_name = "us-east-2"
    session = boto3.session.Session()
    session = boto3.session.Session(profile_name='ec2')
    client = session.client(
      service_name='secretsmanager'
        )
    get_secret_value_response = client.get_secret_value(
                SecretId=secret_name
            )

    database_secrets = json.loads(get_secret_value_response['SecretString'])
    username = database_secrets['username']
    password = database_secrets['password']
    engine   = database_secrets['engine']
    host     = database_secrets['host']
    port     = database_secrets['port']
    dbname   = database_secrets['dbname']
    return (username, password, engine , host, port, dbname)

#username, pw, engine, host, port, dbname = get_secret()
#print (engine)

client = boto3.client('es')
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

#with open('/home/ec2-user/data/taylor2.csv') as f:
#    reader = csv.DictReader(f)
#    helpers.bulk(client, reader, index='swift')
#    for row in reader:
#        print (row['Album'])

query={
  "size": 10,
  "query": {
    "match": {
      "question_text": "does this work with xbox?"
    }
  }
}
res = client.search(index="headset_pqa", body=query)
query_result=[]
for hit in res['hits']['hits']:
    row=[hit['_id'],hit['_score'],hit['_source']['question_text'],hit['_source']['answers'][0]['answer_text']]
    query_result.append(row)

query_result_df = pd.DataFrame(data=query_result,columns=["_id","_score","question","answer"])
print(query_result_df)
print ('+++')


query={
  "size": 10,
  "query": {
    "multi_match": {
      "query": "does this work with xbox?",
      "fields": ["question_text","bullet_point*", "answers.answer_text", "item_name"]
    }
  }
}

res = client.search(index="headset_pqa", body=query)
query_result=[]
for hit in res['hits']['hits']:
    row=[hit['_id'],hit['_score'],hit['_source']['question_text'],hit['_source']['answers'][0]['answer_text']]
    query_result.append(row)

query_result_df = pd.DataFrame(data=query_result,columns=["_id","_score","question","answer"])
print(query_result_df)
print ('+++')

query={
  "size": 10,
  "query": {
    "multi_match": {
      "query": "does this work with xbox?",
      "fields": ["question_text^2", "bullet_point*", "answers.answer_text^2", "item_name^1.5"]
    }
  }
}

res = client.search(index="headset_pqa", body=query)
query_result=[]
for hit in res['hits']['hits']:
    row=[hit['_id'],hit['_score'],hit['_source']['question_text'],hit['_source']['answers'][0]['answer_text']]
    query_result.append(row)

query_result_df = pd.DataFrame(data=query_result,columns=["_id","_score","question","answer"])
print(query_result_df)
print ('+++')

query={
  "query": {
    "bool": {
      "must": [
        {
          "multi_match": {
            "query": "does this work with xbox?",
            "fields": [ "question_text^2", "bullet_point*", "answers.answer_text^2","item_name^2"]
          }
        }
      ],
      "should": [
        {
          "term": {
            "answer_aggregated.keyword": {
              "value": "neutral"
            }
          }
        }
      ]
    }
  }
}

res = client.search(index="headset_pqa", body=query)
query_result=[]
for hit in res['hits']['hits']:
    row=[hit['_id'],hit['_score'],hit['_source']['question_text'],hit['_source']['answers'][0]['answer_text']]
    query_result.append(row)

query_result_df = pd.DataFrame(data=query_result,columns=["_id","_score","question","answer"])
print(query_result_df)
print ('+++')
