#!/usr/bin/python3

import psycopg2
import os
import json
import boto3
import botocore
import botocore.session as bc
from botocore.client import Config
import datetime

now = datetime.datetime.now()
TIMESTAMP = now.strftime("%d.%m.%Y %H:%M:%S")

session = boto3.session.Session()
region = session.region_name

# Initializing Secret Manager's client
client = session.client(
    service_name='secretsmanager',
        region_name=region
    )

get_secret_value_response = client.get_secret_value(
        SecretId='redshift-clu-1-secret'
    )
secret_arn=get_secret_value_response['ARN']
secret = get_secret_value_response['SecretString']
secret_json = json.loads(secret)
cluster_id=secret_json['dbClusterIdentifier']
username=secret_json['username']
password=secret_json['password']
host=secret_json['host']
dbname=secret_json['dbname']
port=secret_json['port']

con=psycopg2.connect(dbname=dbname, host=host, port=port, user=username, password=password )

cur = con.cursor()

#cur.execute("refresh materialized view demo_stream_vw;")
#cur.fetchall()
#cur.execute("SELECT count(*) FROM demo_stream_vw;")
#res=cur.fetchall()


cur.execute("""
SET enable_case_sensitive_identifier to TRUE;
refresh materialized view demo_stream_vw;
SELECT count(*) FROM demo_stream_vw;
""")
res=cur.fetchall()

print (TIMESTAMP + " after mat_view refresh: " + str(res))

cur.close()
con.close()


