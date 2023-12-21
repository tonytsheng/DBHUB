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
# driver.py
# Python database client
#   based on an input parameter of a secrets mgr arn
#     get database connection information
#     run a query over and over until user break
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

SECRET=(sys.argv[1])

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

username, pw, engine, host, port, dbname = get_secret()
#print (engine)

match engine:
    case "oracle":
        # print (username)
        db_dsn = host + ":" + port + "/" + dbname
        print (db_dsn)

        retry_flag = True
        retry_count = 0
        max_retries = 25
        ora_sel=('select * from dba_directories')
        data_inserted = False

        while retry_flag and retry_count < max_retries:
            try:
               client = cx_Oracle.connect(user=username, password=pw, dsn=db_dsn)
               cur = client.cursor()
               cur.execute(ora_sel)
               records = cur.fetchall()
               for row in records:
                   print (row)
               client.commit()
               data_inserted = True
               now = datetime.now()
               print (now.strftime("%Y.%m.%d %H:%M:%S"))
               print (retry_count)
               time.sleep(2)
            except cx_Oracle.Error as error:
               print(error)
               print("retrying..." + str(retry_count))
               retry_count += 1
               time.sleep(5) # wait for 5 seconds between retries
               if retry_count < max_retries:
                   try:
                       client = cx_Oracle.connect(user=username, password=pw, dsn=db_dsn)
                       cur = client.cursor()
                   except Exception as e:
                       print(e)
            #cur.close()
    case _:
        print ('no engine match')





