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
print (engine)

switch (engine) {
    case oracle:
        print('oracle');
        break;
        }





