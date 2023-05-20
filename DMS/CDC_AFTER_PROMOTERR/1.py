#!/usr/bin/python3
#   scratch examples

import boto3
import base64
import json
import decimal
import sys
import getopt
import cx_Oracle
from botocore.exceptions import ClientError
from boto3.dynamodb.conditions import Key
from datetime import date
from datetime import datetime
import time
import datetime

def wait():
    for i in range(12):
        now = datetime.datetime.now()
        date_time = now.strftime("%d.%m.%Y %H:%M:%S")
        print(date_time)
        time.sleep (5)

def get_secret():
#    secret_name = "arn:aws:secretsmanager:us-east-2:070201068661:secret:secret-pg102-WNHBUK"
    secret_name = "arn:aws:secretsmanager:us-east-2:070201068661:secret:pg102-secret-IZWCR2"
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
    password = database_secrets['password']
    return (password)

#------------#------------#------------#------------#------------#------------#
# multiple input arguments
#

src_db=(sys.argv[1])
tgt_db=(sys.argv[2])
now = datetime.datetime.now()
print (now)
TIMESTAMP = now.strftime("%d.%m.%Y %H:%M:%S")
#LOGFILE = SCHEMA+ ".exp.log"
#DUMPFILE = SCHEMA + ".dmp"
#print ("+++ Expdp logfile: " + LOGFILE)

print (src_db)
print (tgt_db)

#------------#------------#------------#------------#------------#------------#
# Set Connection Attributes for Source database
#
conn = None
db_pw = get_secret()
conn = cx_Oracle.connect(user='admin'
         , password=db_pw
         , dsn='ttsora10.ciushqttrpqx.us-east-2.rds.amazonaws.com:1521/ttsora10')

cur = conn.cursor()
#cur.execute(sql_exp)
#time.sleep (10)

#------------#------------#------------#------------#------------#------------#
# Get SCN from source database
#
sql_get_scn = """ Select name, CURRENT_SCN from v$database """
cur.execute(sql_get_scn)
#records = cur.fetchall()
#for row in records:
#    print ("+++ SCN : " + str(row))
record = cur.fetchone()
scn = str(record[1])
print ("SCN: " + scn)
#for row in records:
#    print ("+++ SCN : " + str(row))
cur.close()

#------------#------------#------------#------------#------------#------------#
# parse returned response
#
session = boto3.session.Session()
session = boto3.session.Session(profile_name='dba')
client = session.client(
      service_name='dms'
        )
#response = client.create_endpoint(
#        EndpointIdentifier='ttsora10d',
#        EndpointType='target', 
#        EngineName='oracle', 
#        Username='admin', 
#        Password='Pass1234', 
#        ServerName='ttsora10d.ciushqttrpqx.us-east-2.rds.amazonaws.com', 
#        Port=1521, 
#        DatabaseName='ttsora10'
#        )
response = {'Endpoint': {'EndpointIdentifier': 'ttsora10d', 'EndpointType': 'TARGET', 'EngineName': 'oracle', 'EngineDisplayName': 'Oracle', 'Username': 'admin', 'ServerName': 'ttsora10d.ciushqttrpqx.us-east-2.rds.amazonaws.com', 'Port': 1521, 'DatabaseName': 'ttsora10', 'Status': 'active', 'KmsKeyId': 'arn:aws:kms:us-east-2:012363508593:key/b05c8de8-e561-4676-9d0d-915e765082dd', 'EndpointArn': 'arn:aws:dms:us-east-2:012363508593:endpoint:7YF36NKWDAOVM6X6QRS4IE5YAXJ3HMNHQOKQSKY', 'SslMode': 'none', 'OracleSettings': {'ExtraArchivedLogDestIds': [], 'DatabaseName': 'ttsora10', 'Port': 1521, 'ServerName': 'ttsora10d.ciushqttrpqx.us-east-2.rds.amazonaws.com', 'Username': 'admin'}}, 'ResponseMetadata': {'RequestId': '29bdc1c2-a407-4363-a819-d0aeea0bd067', 'HTTPStatusCode': 200, 'HTTPHeaders': {'x-amzn-requestid': '29bdc1c2-a407-4363-a819-d0aeea0bd067', 'date': 'Sat, 20 May 2023 01:16:25 GMT', 'content-type': 'application/x-amz-json-1.1', 'content-length': '694'}, 'RetryAttempts': 0}}
#print(response)
endpt_arn=response["Endpoint"]["EndpointArn"]
print(endpt_arn)
username=response["Endpoint"]["Username"]
print(username)

#print(row_count)
#while row_count >=1 :
#    time.sleep (5)
#    cur.execute(sql_chk_status)
#    records = cur.fetchall()
#    for row in records:
#        print ("+++ Waiting for job: " + str(row))
#    row_count=cur.rowcount
#    print ( row_count)

#cur.execute(sql_cat_log)
#records = cur.fetchall()
#for row in records:
#    print (row)




