#!/usr/bin/python
# run: python3 ins.ddb.bagtracker.py
# ensure you have boto3 installed

import csv
import time
import socket
import array
import os
from collections import defaultdict
#from uuid import uuid4
import uuid
from pprint import pprint
import boto3
import threading

uuid = str(uuid.uuid4())
#print (uuid)
boto3.setup_default_session(profile_name='ec2')

# PrintMsg
def PrintMsg (msg):
    print (time.strftime("%Y-%m-%d %H:%M:%S") + ": " + msg)

def bagtracker_ins(dynamodb=None):
    import uuid
    uuid = str(uuid.uuid4())
    print (uuid)
    if not dynamodb:
        dynamodb = boto3.resource('dynamodb', region_name='us-east-2')

    table = dynamodb.Table('bagtracker')
    response = table.put_item(
       Item={
            'bagid':     uuid
        }
    )
    return 
#    return response

if __name__ == '__main__':
#    bagtrack_ins_resp = bagtracker_ins(uuid)

    t1 = threading.Thread(target=bagtracker_ins)
    t2 = threading.Thread(target=bagtracker_ins)
    t1.start()
    t2.start()

    t1.join()
#    t2.join()

#    pprint(bagtrack_ins_resp)
# snippet-end:[dynamodb.python.codeexample.MoviesItemOps01]

os.system('aws --profile ec2 dynamodb scan --table-name bagtracker --select "COUNT"')
os.system('aws --profile ec2 dynamodb scan --table-name bagtracker --projection-expression "bagid"')
