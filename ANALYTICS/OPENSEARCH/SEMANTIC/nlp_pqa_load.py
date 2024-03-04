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
from multiprocessing import cpu_count
import json
import pandas as pd
import torch
from transformers import AutoTokenizer, AutoModel
from transformers import DistilBertTokenizer, DistilBertModel

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


#model_name = "distilbert-base-uncased"
#model_name = "sentence-transformers/msmarco-distilbert-base-dot-prod-v3"
model_name = "sentence-transformers/distilbert-base-nli-stsb-mean-tokens"


#Mean Pooling - Take attention mask into account for correct averaging
def mean_pooling(model_output, attention_mask):
    token_embeddings = model_output[0] #First element of model_output contains all token embeddings
    input_mask_expanded = attention_mask.unsqueeze(-1).expand(token_embeddings.size()).float()
    sum_embeddings = torch.sum(token_embeddings * input_mask_expanded, 1)
    sum_mask = torch.clamp(input_mask_expanded.sum(1), min=1e-9)
    return sum_embeddings / sum_mask


def sentence_to_vector(raw_inputs):
    tokenizer = DistilBertTokenizer.from_pretrained(model_name)
    model = DistilBertModel.from_pretrained(model_name)
    inputs_tokens = tokenizer(raw_inputs, padding=True, return_tensors="pt")

    with torch.no_grad():
        outputs = model(**inputs_tokens)

    sentence_embeddings = mean_pooling(outputs, inputs_tokens['attention_mask'])
    return sentence_embeddings

def load_pqa(file_name,number_rows=1000):
    qa_list = []
    df = pd.DataFrame(columns=('question', 'answer'))
    with open(file_name) as f:
        i=0
        for line in f:
            data = json.loads(line)
            df.loc[i] = [data['question_text'],data['answers'][0]['answer_text']]
            i+=1
            if(i == number_rows):
                break
    return df


qa_list = load_pqa('/home/ec2-user/data/amazon-pqa/amazon_pqa_headsets.json',number_rows=1000)
print(qa_list)

vector_sentences = sentence_to_vector(qa_list["question"].tolist())
print(vector_sentences)

i = 0
for c in qa_list["question"].tolist():
    content=c
    vector=vector_sentences[i].tolist()
    answer=qa_list["answer"][i]
    i+=1
    client.index(index='nlp_pqa',body={"question_vector": vector, "question": content,"answer":answer})

res = client.search(index="nlp_pqa", body={"query": {"match_all": {}}})
print("Records found: %d." % res['hits']['total']['value'])

