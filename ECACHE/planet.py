import os
import redis
import pymysql
import psycopg2
import boto3
import base64
import json
from botocore.exceptions import ClientError
import redis

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


def fetch(sql):
    """Retrieve records from the cache, or else from the database."""
    res = cache.get(sql)
    print ('cache get result')
    print (res)

    if res:
        print ('fetch_ from cache')
        return json.loads(res)

    print ('fetch_ from db')
    cur = dbconn.cursor()
    cur.execute(sql)
    record = cur.fetchall()
    print (record)
    cur.close()
    cache.setex(sql, ttl, json.dumps(res))
    return res


def getplanet(id):
    """Retrieve a record from the cache, or else from the database."""
    key = f"planet:{id}"
    res = cache.hgetall(key)

    if res:
        print ('getplanetid_ from cache')
        return res

    print ('getplanetid_ from db')
    sql = "SELECT id, name FROM tutorial.planet WHERE id=%s"
    cur = dbconn.cursor()
    cur.execute(sql,(id,))
    record = cur.fetchall()
    print (record)
    cur.close()

    if res:
        cache.hmset(key, res)
        cache.expire(key, ttl)
    return res


# Initialize the cache
ttl = 10
redis_url = 'redis://ttsecnew.26vdzn.ng.0001.use2.cache.amazonaws.com:6379'
cache = redis.Redis.from_url(redis_url)

sql = ("select * from tutorial.planet")

# Initialize the database
password = get_db_password()
dbconn = psycopg2.connect(user="postgres"
, password=password
, host="pg102.cyt4dgtj55oy.us-east-2.rds.amazonaws.com"
, port="5432"
, database="pg102")


# Display the result of some queries
print(fetch("SELECT * FROM tutorial.planet"))
print(getplanet(2))
print(getplanet(3))
