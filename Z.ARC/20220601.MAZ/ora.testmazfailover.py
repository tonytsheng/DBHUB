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

def execute():
    """ Connect to the Oracle database server """
    conn = None
    db_pw=get_secret()
    try:
        conn = cx_Oracle.connect(user="customer_orders",
                password=db_pw,
                dsn="ttsora10.ciushqttrpqx.us-east-2.rds.amazonaws.com:1521/ttsora10")
		
        cur = conn.cursor()
        sql = "insert into heartbeat values (seq_heartbeat.nextval, :updatedate, :ip)"
        cur.execute(sql, updatedate=datetime.datetime.now(), ip=(ip))
        cur.close()
        conn.commit()
        print ("insert ::: ", ip)

    except (Exception, cx_Oracle.DatabaseError) as error:
        print("Database Error ::: ", error)
    finally:
        if conn is not None:
            conn.close()

def connect():
    db_pw=get_secret()
    dsn = "(DESCRIPTION=(CONNECT_TIMEOUT=10)(ADDRESS=(PROTOCOL=TCP)(HOST=tsora10.ciushqttrpqx.us-east-2.rds.amazonaws.com)(PORT=1521))(CONNECT_DATA=(SID=ttsora10)))"
    try:
        conn = cx_Oracle.connect(user="customer_orders",
            password=db_pw,
            dsn=dsn)
#            dsn="ttsm100.ciushqttrpqx.us-east-2.rds.amazonaws.com:1521/ttsm100")
    except cx_Oracle.DatabaseError as e:
            # Log error as appropriate
        raise

        # If the database connection succeeded create the cursor
        # we-re going to use.


if __name__ == '__main__':
    ip = socket.gethostbyname('ttsora10.ciushqttrpqx.us-east-2.rds.amazonaws.com')
    print (ip)
    print (datetime.datetime.now())
    connect()

