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
while True:
  while not data_inserted:
    try:
       client = cx_Oracle.connect(user=username
             , password=pw
             , dsn=db_dsn)
       cur = client.cursor()
       cur.execute(ora_sel)
       records = cur.fetchall()
       for row in records:
           print (row)
       client.commit()
       data_inserted = True
    except cx_Oracle.Error as error:
     print(error)
     time.sleep(5) # wait for 5 seconds between retries
     retry_count += 1
     if retry_count > 100:
       print(f"Retry count exceeded on record {i}, quitting")
       break
     else:
        # continue to next record if the data was inserted
        continue
        print ('else')
    # retry count was exceeded; break the for loop.
     break


