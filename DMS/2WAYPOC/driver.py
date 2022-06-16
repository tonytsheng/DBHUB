#!/usr/bin/python
import psycopg2
import boto3
import base64
import json
from botocore.exceptions import ClientError
import sys, getopt, psycopg2

SITE=(sys.argv[1])
print ("site input:"+  SITE)

if SITE == "SITEA":
    print ("ORACLE")
else:
    print ("PG")
    conn = None
    try:
        conn = psycopg2.connect(user="postgres"
                , password="Pass1234"
                , host="pg102.cyt4dgtj55oy.us-east-2.rds.amazonaws.com"
                , port="5432"
                , database="pg102")

        # create a cursor
        cur = conn.cursor()

        # execute a statement
#        print('PostgreSQL database version:')
        print('count from countries')
        cur.execute('SELECT * from customer_orders.heartbeat')
        record = cur.fetchall()
        print(record)

        # close the communication with the PostgreSQL
        cur.close()
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
    finally:
        if conn is not None:
            conn.close()
#            print('Database connection closed.')




