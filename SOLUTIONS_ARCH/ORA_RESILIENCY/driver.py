## multi database engine driver used to illustrate
## connection retry logic 
## use this when demonstrating failover
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
#    $ python3 driver.py $SECRET_ARN
#
# ---------------------------------------------------------------------------
#
# History
# 2023-12-20 - Version 1.0
# ---------------------------------------------------------------------------
#
# ToDo
# add more engines
# make selects into inserts
# decide on whether to keep loop in code for resiliency demos
# mongo/docdb doesn't have a database name stored in secretsmanager

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
import psycopg2

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

if engine == "oracle":
    # print (username)
    db_dsn = host + ":" + port + "/" + dbname
    print (db_dsn)

    retry_flag = True
    retry_count = 0
    max_retries = 25
#    ora_sel=('select * from dba_directories')
    ora_sel=(' select product_id, product_name, image_last_updated from (select PRODUCT_ID,PRODUCT_NAME, IMAGE_LAST_UPDATED from customer_orders.products where image_last_updated is not null order by IMAGE_LAST_UPDATED desc) h1 where rownum <=10 order by rownum')
    ora_ins=
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

### postgres
elif engine == "postgres":
    print('postgres')
    conn = psycopg2.connect(user=username,
         password=pw,
         host=host,
         port=port,
         database=dbname)
    cur = conn.cursor()

    # execute a statement
#   print('PostgreSQL database version:')
    print('count from countries')
    cur.execute('SELECT * from human_resources.countries')
    record = cur.fetchall()
    print(record)

    print('count from customer_orders.products')
    cur.execute('SELECT count(*) from customer_orders.products')
    query_out = cur.fetchone()
    print(query_out)

    print('version')
    cur.execute('SELECT version()')
    query_out = cur.fetchone()
    print(query_out)
    conn.close()

### mysql
elif engine == "mysql":
    print('mysql')

### sqlserver
elif engine == "sqlserver":
    print('sqlserver')

### docdb
elif engine == "mongo":
    print('mongo/docdb')
else:
    print ('no engine')





