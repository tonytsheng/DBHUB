## run : python3 driver.py
## will run until user interrupts
## multi database engine driver used to illustrate
## connection retry logic 
## use this when demonstrating failover

import logging
import traceback
import pymongo
import sys
import boto3
from datetime import datetime
from datetime import date
from random import choice
import random
import string
import time
import json
import cx_Oracle

def get_secret():
    secret_name = "arn:aws:secretsmanager:us-east-2:070201068661:secret:ttsora10-secret-tOICMD"
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

username, pw, engine, host, port, dbname = get_secret()
# print (username)
db_dsn = host + ":" + port + "/" + dbname
print (db_dsn)

ora_sel=('select * from dba_directories')
data_inserted = False
try:
#    print("Attempting to connect...")
    client = cx_Oracle.connect(user=username
             , password=pw
             , dsn=db_dsn)
    cur = client.cursor()
    i = 0
    while True or retry_flag:
        try:
            cur.execute(ora_sel)
            records = cur.fetchall()
            for row in records:
                print (row)
            i += 1
            print(retry_flag)
            now = datetime.now()
            print (now.strftime("%Y.%m.%d %H:%M:%S"))
            time.sleep(3)
        except cx_Oracle.DatabaseError as e:
            print(retry_flag)
            print("ConnectionFailure seen: " + str(e))
            print(sys.stdout)
            traceback.print_exc(file = sys.stdout)
            print("Retrying...")
            retry_count = retry_count + 1
            time.sleep(3)
    print("Done...")
except Exception as e:
    print("Exception seen: " + str(e))
    traceback.print_exc(file = sys.stdout)
finally:
    client.close()

