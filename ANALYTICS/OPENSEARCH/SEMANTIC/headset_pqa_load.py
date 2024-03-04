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

def load_pqa_as_json(file_name,number_rows=1000):
    result=[]
    with open(file_name) as f:
        i=0
        for line in f:
            data = json.loads(line)
            result.append(data)
            i+=1
            if(i == number_rows):
                break
    return result

qa_list_json = load_pqa_as_json('/home/ec2-user/data/amazon-pqa/amazon_pqa_headsets.json',number_rows=1000)

def es_import(question):
    client.index(index='headset_pqa', body=question)

#workers = 4 * cpu_count()

process_map(es_import, qa_list_json,chunksize=1000)


