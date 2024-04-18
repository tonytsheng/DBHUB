#MIT No Attribution

#Copyright 2021 Amazon.com, Inc. or its affiliates.

#Permission is hereby granted, free of charge, to any person obtaining a copy of this
#software and associated documentation files (the "Software"), to deal in the Software
#without restriction, including without limitation the rights to use, copy, modify,
#merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
#permit persons to whom the Software is furnished to do so.

#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
#INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
#PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
#HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
#OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
#SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import sys
import boto3
import logging
import urllib.parse
import cfnresponse
import os
import time
#from pip._internal import main
# install pg8000
#main(['install', '-I', '-q', 'pg8000', '--target', '/tmp/', '--no-cache-dir', '--disable-pip-version-check'])
#sys.path.insert(0,'/tmp/')
import pg8000

# declare the global connection object to use during warm starting
# to reuse connections that were established during a previous invocation.
connection = None

def get_connection(DBEndPoint, DatabaseName, DBUserName, password):
    """
        Method to establish the connection.
    """
    try:
        print ("Connecting to database")
        # Establishes the connection with the server
        conn = pg8000.connect(
            host=DBEndPoint,
            user=DBUserName,
            database=DatabaseName,
            password=password,
            port=3306,
            ssl_context=True
        )
        return conn
    except Exception as e:
        print ("While connecting failed due to :{0}".format(str(e)))
        return None

def lambda_handler(event, context):
    global connection
    print('## EVENT')
    print(event)
    eventtype = event['RequestType']
    response_data = {}
    
    try:
        if eventtype in ('Create', 'Update'):
            data_source_prefix = event['ResourceProperties']['data_source_prefix']
            data_source_bucket = event['ResourceProperties']['data_source_bucket']
            data_source_region = event['ResourceProperties']['data_source_region']
            sql_createtable_reviews = "CREATE TABLE if not exists reviews (	id serial PRIMARY KEY, product_id varchar(40), comment VARCHAR ( 1024 ) NOT NULL, rating int NOT NULL, name VARCHAR ( 255 ) NOT NULL,	created_on TIMESTAMP NOT NULL);"
            sql_createtable_product = "create table if not exists product (product_id varchar(40) primary key, product_name varchar(255),price double precision, quantity bigint, product_category varchar(255));"
            sql_create_ext = "CREATE EXTENSION IF NOT EXISTS aws_s3 CASCADE;"
            sql_import = "select aws_s3.table_import_from_s3 ('product','','(format csv)','"+data_source_bucket+"','"+data_source_prefix+"data/products.csv','"+data_source_region+"');"
            
            if connection is None:
                pw = event['ResourceProperties']['pw']
                host = event['ResourceProperties']['host']
                database = "mdacluster"
                user = "mdauser"
                connection = get_connection(host,database,user,pw)
            if connection is None:
                return {"status": "Error", "message": "Failed"}
                
            
            print ("instantiating the cursor from connection")
            # Instantiate the cursor object
            dbcur = connection.cursor()
            # Query to be executed
            print('Execute Review')
            connection.run(sql_createtable_reviews)
            time.sleep(5)
            print('Execute Product')
            connection.run(sql_createtable_product)
            time.sleep(5)
            print('Execute Ext')
            connection.run(sql_create_ext)
            time.sleep(5)
            print('Execute Import')
            connection.run(sql_import)
            time.sleep(5)
            connection.run("COMMIT")
           # results = dbcur.fetchall()
            print(connection.run("select count(*) from product"))
            dbcur.close()
        elif eventtype == 'Delete':
            print("nothing doing here, for now")
        print("Execution succesful!")
        cfnresponse.send(event,context,cfnresponse.SUCCESS,response_data)
    except Exception as e:
        try:
            connection.close()
        except Exception as e:
            connection = None
        print ("Failed due to :{0}".format(str(e)))
        response_data['Data'] = "an error occurred"
        cfnresponse.send(event,context,cfnresponse.FAILED,response_data)
        return {"status": "Error", "message": "Something went wrong. Try again"}