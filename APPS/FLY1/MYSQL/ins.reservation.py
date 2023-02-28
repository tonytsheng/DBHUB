#!/usr/bin/env python3
#----------------------------------------------------------------------------
# Created By  : Tony Sheng ttsheng@amazon.com
# Created Date: 2022-11-21
# version ='1.0'
# ---------------------------------------------------------------------------
#
# ins.reservation.py
# Python database client
#   to use for FLY1 proof of concept
#   must have data loaded 
#   inserts rows into the reservation table and uses random 
#     data from other tables to do the insert
#
# ---------------------------------------------------------------------------
#
# To run:
#    $ python3 ins.reservation.py
#
# ---------------------------------------------------------------------------
#
# History
# 2022-11-21 - Version 1.0 - limited to Oracle database engine
# ---------------------------------------------------------------------------
#
# ToDo


import psycopg2 
import mysql.connector
import boto3
import base64
import json
import decimal
import sys
import getopt
import cx_Oracle
import cx_Oracle
from botocore.exceptions import ClientError
from boto3.dynamodb.conditions import Key
from datetime import date
from datetime import datetime
from random import seed
from random import randint
import random

# get some random values for seat numbers and flight numbers
seatnumber = randint(0,50)
letters = ['A','B','C','D','E','F','G','H','I','J']
seatletter = str(random.sample(letters,1)[0])
seat=str(seatnumber)+seatletter
flightnumber = str(randint(0,999))

#print (seatnumber)
#print (seatletter)
#print (seat)
#print (flightnumber)

#SITE=(sys.argv[1])
#print ("site input:"+  SITE)

#def get_secret():
#    secret_name = "arn:aws:secretsmanager:us-east-2:070201068661:secret:secret-pg102-WNHBUK"
#    region_name = "us-east-2"
#    session = boto3.session.Session()
#    session = boto3.session.Session(profile_name='ec2')
#    client = session.client(
#      service_name='secretsmanager'
#        )
#    get_secret_value_response = client.get_secret_value(
#                SecretId=secret_name
#            )
#    database_secrets = json.loads(get_secret_value_response['SecretString'])
#    password = database_secrets['password']
#    return (password)

#boto3.setup_default_session(profile_name='ec2')
#dynamodb = boto3.resource('dynamodb', region_name='us-east-2')
#table = dynamodb.Table('appmap')

#response = table.get_item(
#    Key={ 'site': SITE } ,
#)

#appmap_resp = response['Item']
#for key in appmap_resp:
#    print (key, '->', appmap_resp[key])

#db_engine=appmap_resp['dbengine']
#db_endpoint=appmap_resp['endpoint']
#db_port=appmap_resp['port']
#db_name=appmap_resp['dbname']
#db_user=appmap_resp['username']
#db_dsn = db_endpoint + ":" + db_port + "/" +db_name
#print(db_dsn)

#if db_engine == "oracle":
#    print ("ORACLE")
#conn = None
sql_ins = ('insert into reservation values ('
  'reservation_seq.nextval, '
  '  (select * from (select last_name from employee order by dbms_random.value) where rownum <=1), '
  '  (select * from (select first_name from employee order by dbms_random.value) where rownum <=1), '
  + '\'' + seat + ',\''', '
  '  (select * from (select iata || ' + flightnumber + ' from airline where iata is not null order by dbms_random.value) where rownum <=1), '
#  ' \'AA123\', '
  '  (select * from (select iata_code from airport order by dbms_random.value) where rownum <=1), '
  '  (select * from (select iata_code from airport order by dbms_random.value) where rownum <=1), '
  '  sysdate) '
  )

#print (sql_ins)
sql_sel = (' SELECT * '
'  FROM (select id, lname, fname, seatno, flightno, dep, arr, reservedate from reservation ORDER BY reservedate desc) h1 '
'  WHERE rownum <= 20 ' 
'  ORDER BY rownum ' )

try:
#  db_pw = get_secret()
  conn = cx_Oracle.connect(user='fly1'
      , password='fly1'
      , dsn='ttsora10.ciushqttrpqx.us-east-2.rds.amazonaws.com:1521/ttsora10')
#  print (conn)
  cur = conn.cursor()
  cur.execute(sql_ins)
  conn.commit()
  cur.execute(sql_sel)
#  print (sql_sel)
  records = cur.fetchall()
  for row in records:
    print (row)
  cur.close()
finally:
  if conn is not None:
    conn.close()
  else:
    conn.close()
#    print ("PG")
#    conn = None
#    db_pw = get_secret()
#    sql_ins = ('INSERT into customer_orders.heartbeat (heartbeat_id, last_update_dt, last_update_site) '
#            ' VALUES (nextval(\'customer_orders.seq_heartbeat\') ,now(), %s)'
#               )
#    print (sql_ins)
#    sql_sel  = ('SELECT * FROM (SELECT * FROM customer_orders.heartbeat ORDER BY '
#                 ' last_update_dt DESC LIMIT 5) h1 ORDER BY last_update_dt desc'
#               )
#    try:
#        conn = psycopg2.connect(user=db_user
#             , password=db_pw
#             , host=db_endpoint
#             , port=db_port
#             , database=db_name)
#
#        cur = conn.cursor()
#        cur.execute(sql_ins, [SITE])
#        conn.commit()
#        cur.execute(sql_sel)
#        records = cur.fetchall()
#        for row in records:
#            print(row)
#        # close the communication with the PostgreSQL
#        cur.close()
#    except (Exception, psycopg2.DatabaseError) as error:
#        print(error)
#    finally:
#        if conn is not None:
#            conn.close()
#            print('Database connection closed.')
