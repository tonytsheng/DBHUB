## python3 queryairport.py

import os
#import pymysql
import psycopg2
import boto3
import base64
import json
from botocore.exceptions import ClientError
import redis
import logging
import time
import sys
import getopt

def get_db_password():
    secret_name = "arn:aws:secretsmanager:us-east-2:070201068661:secret:secret-pg102-WNHBUK"
    region_name = "us-east-2"
    # Create a Secrets Manager client
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
    return password


def queryDB (id):
    sql = "SELECT * FROM fly.airport WHERE iata_code=%s"
    cur = dbconn.cursor()
    cur.execute(sql,(id,))
    record = cur.fetchone()
    logging.info("from queryDB: {}".format(record))
    cur.close()
    time.sleep(1)

def queryCache (id):
    keyName="airport:"+ id
    keyValues=cache.hgetall(keyName)
    keyTTL=cache.ttl(keyName)
    logging.info("from queryCache Key {} and KeyValues  {}".format(keyName, keyValues))

# Set up logging
logging.basicConfig(level=logging.INFO,format='%(asctime)s: %(message)s', datefmt='%m/%d/%Y %H:%M:%S ')
#sheng='sheng'
#logging.info("Logging {}".format(sheng))

# Initialize the cache
ttl = 10
redis_url = 'redis://ttsecnew.26vdzn.ng.0001.use2.cache.amazonaws.com:6379'
cache = redis.Redis.from_url(redis_url)

# Initialize the database
password = get_db_password()
dbconn = psycopg2.connect(user="postgres"
, password=password
, host="pg102.cyt4dgtj55oy.us-east-2.rds.amazonaws.com"
, port="5432"
, database="pg102")

destDataStore = ''
#logging.info("This is the name of the script: {}".format(sys.argv[0]))
#logging.info("Number of arguments: {}".format(len(sys.argv)))
#logging.info("The arguments are: {}" .format(str(sys.argv)))

destDataStore = sys.argv[1]
#logging.info("t1 {}" .format(destDataStore))
#logging.info("dest - {}" .format(destDataStore))

if destDataStore == 'database':
    queryDB('CDG')
else: 
    queryCache('CDG')

