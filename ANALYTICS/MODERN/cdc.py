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
import os

    
import pg8000
def lambda_handler(event, context):
    print('## EVENT')
    print(event)
    
    
    sql_insert = 'insert into reviews (product_id, comment, rating, name, created_on) values (\'' + event['product_id'] + '\',\''+event['comment']+'\', '+event['rating']+',\''+ event['name']+'\', CURRENT_TIMESTAMP);'
    print(sql_insert)
    pw = os.environ['PW']
    host = os.environ['HOST']

    conn = pg8000.connect(
        database='mdacluster',
        user='mdauser',
        password=pw,
        host=host,
        port=3306,
        ssl_context=True
        )
    
    dbcur = conn.cursor()
    conn.run(sql_insert)
    
    conn.run("COMMIT")
    dbcur.close()

    print("Execution succesful!")
    return str("Success")