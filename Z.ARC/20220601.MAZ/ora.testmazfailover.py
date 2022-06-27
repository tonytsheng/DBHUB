#!/usr/bin/env python3
# to run: python3 connect.ora.py

#import psycopg2
import cx_Oracle
import os
import socket
import datetime
#from config import config
import boto3
import json
import subprocess
from subprocess import Popen, PIPE


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
    try:
        conn = cx_Oracle.connect(user="admin",
            password=db_pw,
            dsn=dsn)
        sql = "select name from v$database"
        cur = conn.cursor()
        cur.execute(sql)
        records = cur.fetchone()
        cur.close()
    except cx_Oracle.DatabaseError as e:
        print("Database Error ::: ", e)
    return records


if __name__ == '__main__':
    dsn =  "(DESCRIPTION=(CONNECT_TIMEOUT=10)(ADDRESS=(PROTOCOL=TCP)(HOST=ttsora30.ciushqttrpqx.us-east-2.rds.amazonaws.com)(PORT=1521))(CONNECT_DATA=(SID=ttsora30)))"
    timestamp = str(datetime.datetime.now())
    ip = socket.gethostbyname('ttsora30.ciushqttrpqx.us-east-2.rds.amazonaws.com')
    dbstatus1 = subprocess.run(['/usr/bin/aws rds describe-db-instances --profile dba --db-instance-identifier ttsora30 | grep DBInstanceStatus'], shell=True, text=True, stdout=PIPE)
    dbstatus = dbstatus1.communicate()
    dbcheck = str(connect())
    print (timestamp + " ::: " + ip + " ::: " + " ::: " + dbstatus + " ::: " + dbcheck)

