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

# TODO def get_ddb_creds()
boto3.setup_default_session(profile_name='ec2')
dynamodb = boto3.resource('dynamodb', region_name='us-east-2')
table = dynamodb.Table('appmap')
# TODO use getitem instead - ensure this is only one returned row
#response = table.query(
#           KeyConditionExpression=Key('site').eq(SITE)
#)
print ("before get_item")

response = table.get_item(
    Key={ 'site': { 'S': 'SITEA' } 
        }
)
print ("after get_item")

for i in response['Items']:
    print (i['dbname'], ":", i['username'])
    db_engine = (i['dbengine'])
    db_endpoint = (i['endpoint'])
    db_port = str((i['port']))
    db_name = (i['dbname'])
    db_dsn = db_endpoint + ":" + db_port + "/" +db_name
#    print (db_dsn)

if db_engine == "oracle":
#    print ("ORACLE")
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
#             , dsn="ttsora10.ciushqttrpqx.us-east-2.rds.amazonaws.com:1521/ttsora10")
             , dsn=db_dsn)
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
    db_pw = get_secret()
    sql_ins = ('INSERT into customer_orders.heartbeat (heartbeat_id, last_update_dt, last_update_site) '
            ' VALUES (nextval(\'customer_orders.seq_heartbeat\') ,now(), %s)'
               )
#    print (sql_ins)
    sql_sel  = ('SELECT * FROM (SELECT * FROM customer_orders.heartbeat ORDER BY '
                 ' last_update_dt DESC LIMIT 5) h1 ORDER BY last_update_dt desc'
               )
    try:
        conn = psycopg2.connect(user="postgres"
             , password=db_pw
             , host=db_endpoint
             , port=db_port
             , database=db_name)

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




