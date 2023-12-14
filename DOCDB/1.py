import pymongo
import sys

##Create a MongoDB client, open a connection to Amazon DocumentDB as a replica set and specify the read preference as secondary preferred
client = pymongo.MongoClient('mongodb://docadmin:Pass1234@docdb100.cluster-cyt4dgtj55oy.us-east-2.docdb.amazonaws.com:27017/?tls=true&tlsCAFile=/home/ec2-user/ssl/global-bundle.pem&replicaSet=rs0&readPreference=secondaryPreferred&retryWrites=false')

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

##Print the result to the screen
print(x)

##Close the connection
client.close()
