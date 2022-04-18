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
    res = Cache.get(sql)
    print ('cache get result')
    print (res)

    if res:
        print ('fetch_ from cache')
        return json.loads(res)

    print ('from db')
    cur = DBConn.cursor()
    cur.execute(sql)
    record = cur.fetchall()
    print (record)
    cur.close()
    Cache.setex(sql, TTL, json.dumps(res))
    return res


def getplanet(id):
    """Retrieve a record from the cache, or else from the database."""
    key = f"planet:{id}"
    res = Cache.hgetall(key)

    if res:
        print ('getplanetid_ from cache')
        return res

    print ('from db')
    sql = "SELECT id, name FROM tutorial.planet WHERE id=%s"
    cur = DBConn.cursor()
    cur.execute(sql,(id,))
    record = cur.fetchall()
    print (record)
    cur.close()

    if res:
        Cache.hmset(key, res)
        Cache.expire(key, TTL)
    return res

# Time to live for cached data
TTL = 60
REDIS_URL = 'redis://ttsecnew.26vdzn.ng.0001.use2.cache.amazonaws.com:6379'
sql = ("select * from tutorial.planet")

# Initialize the database
#Database = DB(host=DB_HOST, user=DB_USER, password=DB_PASS, db=DB_NAME)
password = get_db_password()
#print (password)
DBConn = psycopg2.connect(user="postgres"
, password=password
, host="pg102.cyt4dgtj55oy.us-east-2.rds.amazonaws.com"
, port="5432"
, database="pg102")

# Initialize the cache
Cache = redis.Redis.from_url(REDIS_URL)

# Display the result of some queries
print(fetch("SELECT * FROM tutorial.planet"))
#print(getplanet(1))
print(getplanet(2))
print(getplanet(3))
