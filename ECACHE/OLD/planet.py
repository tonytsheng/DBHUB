import os
import pymysql
import psycopg2
import boto3
import base64
import json
from botocore.exceptions import ClientError
import redis
import logging
import time

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


def setkey (id, secs):

    keyName=id
#    keyValues={'datetime': time.ctime(time.time()), 'epochtime': time.time()}

    sql = "SELECT name FROM tutorial.planet WHERE id=%s"
    cur = dbconn.cursor()
    cur.execute(sql,(id,))
#    record = cur.fetchall()
    record = cur.fetchone()
#    logging.info("record: {}".format(record))
    record = format(record)
    keyValues={'name': (record)}
#    logging.info("keyvalues: {}".format(keyValues))
    cur.close()
    cache.hset(keyName, mapping=keyValues)

# Set the key to expire and removed from cache in X seconds.
    cache.expire(keyName, 2)

# Retrieves all the fields and current TTL
    keyValues=cache.hgetall(keyName)
    keyTTL=cache.ttl(keyName)

    if keyValues:
        logging.info("cache hit")

    else:
        logging.info("cache miss")

    logging.info("Key {} was set at {} and has {} seconds until expired".format(keyName, keyValues, keyTTL))

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

setkey(2, 1)
# Sleep just for better illustration of TTL (expiration) value
#time.sleep(1)
setkey(4, 5)
#time.sleep(5)
setkey(6, 1)
setkey(8, 5)

#keyValues=cache.hgetall()
keyValues=cache.keys("*")
logging.info("first cache scan ")
for k in enumerate(keyValues):
    logging.info("first cache scan {} ".format(k))

time.sleep(5)
#keyValues=cache.hgetall()
keyValues=cache.keys("*")
logging.info("second cache scan ")
for k in enumerate(keyValues):
    logging.info("second cache scan {} ".format(k))
