## run : python3 insert_test.py
## will run until user hits control c

import logging
import traceback
import pymongo
import sys
import boto3
from datetime import datetime
from random import choice
import random
import string
import time
import json

#logger = logging.getLogger("test")

def get_secret():
    secret_name = "arn:aws:secretsmanager:us-east-2:070201068661:secret:docdb100-jtIFbV"
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

username='docadmin'
pw=get_secret()

try:
    print("Attempting to connect...")
    client = pymongo.MongoClient('mongodb://%s:%s@docdb100.cluster-cyt4dgtj55oy.us-east-2.docdb.amazonaws.com:27017/admin?replicaSet=rs0&readPreference=secondaryPreferred&retryWrites=false' % (username, pw))

    db = client['test']
    collection = db['test']
    i = 0
    while True:
        try:
            text = ''.join(random.choices(string.ascii_uppercase + string.digits, k = 3))
            doc = { "idx": i, "date" : datetime.utcnow(), "text" : text}
            i += 1
            id = collection.insert_one(doc).inserted_id
            print("Record inserted - id: " + str(id))
            time.sleep(3)
        except pymongo.errors.ConnectionFailure as e:
            print("ConnectionFailure seen: " + str(e))
            print(sys.stdout)
            traceback.print_exc(file = sys.stdout)
            print("Retrying...")

    print("Done...")
except Exception as e:
    print("Exception seen: " + str(e))
    traceback.print_exc(file = sys.stdout)
finally:
    client.close()

