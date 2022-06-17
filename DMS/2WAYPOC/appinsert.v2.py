#!/usr/bin/python

## python3 appinsert.v2.py $SITE
import psycopg2 
import boto3
import base64
import json
import sys
import getopt
import cx_Oracle
import cx_Oracle
from botocore.exceptions import ClientError
from boto3.dynamodb.conditions import Key
from datetime import date
from datetime import datetime

SITE=(sys.argv[1])
#print ("site input:"+  SITE)

boto3.setup_default_session(profile_name='ec2')
dynamodb = boto3.resource('dynamodb', region_name='us-east-2')
table = dynamodb.Table('appmap')

# ensure this is only one returned row
response = table.query(
           KeyConditionExpression=Key('site').eq(SITE)
)

#i = response ['Items']
#site_input = (i['dbengine'])
#print (site_input)

for i in response['Items']:
    print (i['dbname'], ":", i['username'])
    site_input = (i['dbengine'])

if site_input == "oracle":
    print ("ORACLE")
    conn = None
    sql_ins = ('INSERT into heartbeat (heartbeat_id, last_update_dt, last_update_site) '
              'VALUES (seq_heartbeat.nextval, sysdate, :site)'
              )
    sql_sel = ('SELECT * FROM (SELECT heartbeat_id, last_update_dt, last_update_site '
              ' FROM heartbeat ORDER BY last_update_dt desc) h1'
              ' WHERE rownum <= 5'
              ' ORDER BY rownum'
              )

    try:
        conn = cx_Oracle.connect(user="customer_orders"
             , password="Pass1234"
             , dsn="ttsora10.ciushqttrpqx.us-east-2.rds.amazonaws.com:1521/ttsora10")
        cur = conn.cursor()
        cur.execute(sql_ins, [SITE])
        conn.commit()
        cur.execute(sql_sel)
        records = cur.fetchall()
        for row in records:
            print (row)
        cur.close()
    finally:
        if conn is not None:
            conn.close()
else:
    print ("PG")
    conn = None
    sql_ins = ('INSERT into customer_orders.heartbeat (heartbeat_id, last_update_dt, last_update_site) '
            ' VALUES (nextval(\'customer_orders.seq_heartbeat\') ,now(), %s)'
               )
    print (sql_ins)

    sql_sel  = ('SELECT * FROM (SELECT * FROM customer_orders.heartbeat ORDER BY '
                 ' last_update_dt DESC LIMIT 5) h1 ORDER BY last_update_dt desc'
               )
    try:
        conn = psycopg2.connect(user="postgres"
             , password="Pass1234"
             , host="pg102.cyt4dgtj55oy.us-east-2.rds.amazonaws.com"
             , port="5432"
             , database="pg102")

        # create a cursor
        cur = conn.cursor()
        cur.execute(sql_ins, [SITE])
        conn.commit()
        cur.execute(sql_sel)
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




