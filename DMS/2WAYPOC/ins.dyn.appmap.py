#!/usr/bin/python
# run: python ins.ddb.appmap.y
# ensure you have boto3 installed

import csv
import time
import socket
import array
import os
from collections import defaultdict

# PrintMsg
def PrintMsg (msg):
    print (time.strftime("%Y-%m-%d %H:%M:%S") + ": " + msg)

host = socket.gethostname().split('.',1)[0]
PrintMsg("HOST: " + host)
ssirep = "/home/user/dba_arch/scripts/install/ssi/rep." + host
PrintMsg("SSI_REP: " + ssirep)

# snippet-start:[dynamodb.python.codeexample.MoviesItemOps01]
from pprint import pprint
import boto3
boto3.setup_default_session(profile_name='ec2')

def put_appmap(site, dbengine, username, endpoint, port, dbname, dynamodb=None):
    if not dynamodb:
        dynamodb = boto3.resource('dynamodb', region_name='us-east-2')

    table = dynamodb.Table('appmap')
    response = table.put_item(
       Item={
            'site':     site,
            'dbengine': dbengine,
            'username':     username,
            'endpoint': endpoint,
            'port': port,
            'dbname':   dbname
        }
    )
    return response

if __name__ == '__main__':
    appmap_resp = put_appmap('SITEA', 'oracle', 'customer_orders', 'ttsora10.ciushqttrpqx.us-east-2.rds.amazonaws.com', '1521', 'ttsora10' ) 
    appmap_resp = put_appmap('SITEB', 'postgresql','postgres','pg102.cyt4dgtj55oy.us-east-2.rds.amazonaws.com','5432', 'pg102' ) 
    print("Put appmap succeeded:")
    pprint(appmap_resp)
# snippet-end:[dynamodb.python.codeexample.MoviesItemOps01]

os.system('aws --profile ec2 dynamodb scan --table-name appmap --select "COUNT"')
