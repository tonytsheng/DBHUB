#!/usr/bin/python
import psycopg2
import boto3
import base64
import json
from botocore.exceptions import ClientError
import redis

# initialize vars
TTL=10

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

def fetch(password, id):
    REDIS_URL = 'redis://ttsecnew.26vdzn.ng.0001.use2.cache.amazonaws.com:6379'
    Cache = redis.Redis.from_url(REDIS_URL)

    DBConn = psycopg2.connect(user="postgres"
      , password=password
      , host="pg102.cyt4dgtj55oy.us-east-2.rds.amazonaws.com"
      , port="5432"
      , database="pg102")

    sql = "SELECT employee_id, last_name FROM human_resources.employees WHERE employee_id= (%s);"
    id = ("115",)
    print ('sql : ' + sql)
    cur = DBConn.cursor()
    cur.execute(sql, id,)
    record = cur.fetchall()
    cur.close()

#    res = Cache.get(sql, id)
#    record = res.fetchall()
#    print (id)

#    key = f"planet:{id}"
#    res = Cache.hgetall(key)

#    if res:
#        print ('returning from cache')
#        return json.loads(res)
#        return (res)

#    print ('returning from database')

#    Cache.setex(sql, TTL, json.dumps(res))
    return record

if __name__ == '__main__':
    dbpw = get_db_password()
    print(fetch(dbpw, "115"))
#    print(fetch(dbpw, 'select * from human_resources.jobs'))
#    print(fetch(dbpw, 'select version()'))

