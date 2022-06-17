#!/usr/bin/python
import psycopg2 
import boto3
import base64
import json
from botocore.exceptions import ClientError
import sys
import getopt
import cx_Oracle

SITE=(sys.argv[1])
print ("site input:"+  SITE)

if SITE == "SITEA":
    print ("ORACLE")
    conn = None
    inssql = ('insert into heartbeat (heartbeat_id, last_update_dt, last_update_site) '
            'values (seq_heartbeat.nextval,:sysdate, :site)')
    print (inssql)
    querysql = ('SELECT * FROM (select heartbeat_id, last_update_dt, last_update_site '
        ' from heartbeat ORDER BY last_update_dt desc) h1'
        ' WHERE rownum <= 5'
        ' ORDER BY rownum')

    try:
        conn = cx_Oracle.connect(user="customer_orders",
            password="Pass1234",
            dsn="ttsora10.ciushqttrpqx.us-east-2.rds.amazonaws.com:1521/ttsora10")
        cur = conn.cursor()
        cur.execute(querysql)
        records = cur.fetchall()
        for row in records:
            print (row)
#        print('++ %s \n' query_out)
        cur.close()
    finally:
        if conn is not None:
            conn.close()
else:
    print ("PG")
    conn = None
    querysql  = ('SELECT * FROM (SELECT * FROM customer_orders.heartbeat ORDER BY '
        ' last_update_dt DESC LIMIT 5) h1 ORDER BY last_update_dt desc')
    try:
        conn = psycopg2.connect(user="postgres"
                , password="Pass1234"
                , host="pg102.cyt4dgtj55oy.us-east-2.rds.amazonaws.com"
                , port="5432"
                , database="pg102")

        # create a cursor
        cur = conn.cursor()
        cur.execute(querysql)
        records = cur.fetchall()
        for row in records:
            print(row)
        # close the communication with the PostgreSQL
        cur.close()
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
    finally:
        if conn is not None:
            conn.close()
#            print('Database connection closed.')




