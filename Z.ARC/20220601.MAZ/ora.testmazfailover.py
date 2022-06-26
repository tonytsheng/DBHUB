#!/usr/bin/python
# to run: python3 connect.ora.py

#import psycopg2
import cx_Oracle
import os
import socket
import datetime
#from config import config
import boto3
import json


def get_secret():
    secret_name = "arn:aws:secretsmanager:us-east-2:070201068661:secret:secret-pg102-WNHBUK"
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
    password = database_secrets['password']
    return (password)

def connect():
    db_pw=get_secret()
#    dsn = dsn
    try:
        conn = cx_Oracle.connect(user="admin",
            password=db_pw,
            dsn=dsn)
        sql = "select name from v$database"
        cur = conn.cursor()
        cur.execute(sql)
        records = cur.fetchone()
        for row in records:
            print (row)
        cur.close()
    except cx_Oracle.DatabaseError as e:
        print("Database Error ::: ", e)


if __name__ == '__main__':
    dsn =  "(DESCRIPTION=(CONNECT_TIMEOUT=10)(ADDRESS=(PROTOCOL=TCP)(HOST=ttsora30.ciushqttrpqx.us-east-2.rds.amazonaws.com)(PORT=1521))(CONNECT_DATA=(SID=ttsora30)))"
    print (datetime.datetime.now())
    ip = socket.gethostbyname('ttsora30.ciushqttrpqx.us-east-2.rds.amazonaws.com')
    print (ip)
    connect()

