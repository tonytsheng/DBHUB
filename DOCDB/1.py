import pymongo
import sys
import boto3
import json

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
#print (pw)

##Create a MongoDB client, open a connection to Amazon DocumentDB as a replica set and specify the read preference as secondary preferred
client = pymongo.MongoClient('mongodb://%s:%s@docdb100.cluster-cyt4dgtj55oy.us-east-2.docdb.amazonaws.com:27017/?tls=true&tlsCAFile=/home/ec2-user/ssl/global-bundle.pem&replicaSet=rs0&readPreference=secondaryPreferred&retryWrites=false' % (username, pw))

##Specify the database to be used
db = client.test

##Specify the collection to be used
col = db.listings2

##Insert a single document
col.insert_one({'hello':'Amazon DocumentDB'})

##Find the document that was previously written
#x = col.find_one({'country_code':'USA'} )
x = col.count()
# x = col.find_one({'country_code':'USA'}, {country_code:1})
#x = col.find({'country_code':'USA'})

print(x)

db = client.admin
db_status = db.command({'replSetGetStatus'  :1 })
print(db_status)

##Close the connection
client.close()
