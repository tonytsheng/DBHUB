#!/usr/bin/python
import psycopg2
import boto3
import base64
import json
from botocore.exceptions import ClientError

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

def dbfetch(password, sql):
    conn = None
    try:
        conn = psycopg2.connect(user="postgres"
                , password=password
                , host="pg102.cyt4dgtj55oy.us-east-2.rds.amazonaws.com"
                , port="5432"
                , database="pg102")
		
        # create a cursor
        cur = conn.cursor()
        cur.execute(sql)
        record = cur.fetchall()
        print(record)
        cur.close()
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
    finally:
        if conn is not None:
            conn.close()

def fetch(sql):
    res = Cache.get(sql)

    if res:
        return json.loads(res)

    res = Database.query(sql)
    Cache.setex(sql, TTL, json.dumps(res))
    return res


if __name__ == '__main__':
    dbpw = get_db_password()
    dbfetch(dbpw, 'select count(*) from human_resources.employees')
    dbfetch(dbpw, 'select * from human_resources.jobs')
    dbfetch(dbpw, 'select version()')

