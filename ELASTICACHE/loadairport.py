import os
import pymysql
import psycopg2
import boto3
import base64
import json
from botocore.exceptions import ClientError
import redis
import logging
import time
import glob
import csv

def loadcache (filename, secs):
    logging.info("begin script")
    files = glob.glob(filename)
    for filename in files:
        with open(filename, 'r', encoding="utf-8") as csvfile:
            myreader = csv.reader(csvfile, delimiter=',')
            for row in myreader:
                rowdata = {}
#               should look like iata:CDG
                rowdata["name"] = row[2]
                rowdata["continent"] = row[4]
                rowdata["country"] = row[5]
                rowdata["gps_code"] = row[8]
                rowdata["coords"] = row[11]
                keyName= "airport:"+ row[9]
                logging.info("%s %s"  % (keyName, rowdata))
                cache.hmset(keyName, rowdata)
                cache.expire(keyName, 604800)
    logging.info("cache load done")


def checkcache ():
    #keyValues=cache.hgetall()
    keyValues=cache.keys("*")
#    logging.info("checking cache ")
    for k in enumerate(keyValues):
        logging.info("cache check {} ".format(k))


## main
logging.basicConfig(level=logging.INFO,format='%(asctime)s: %(message)s', datefmt='%m/%d/%Y %H:%M:%S ')

# Initialize the cache
ttl = 10
redis_url = 'redis://ttsecnew.26vdzn.ng.0001.use2.cache.amazonaws.com:6379'
cache = redis.Redis.from_url(redis_url)

loadcache("/home/ec2-user/DBHUB/BASEDAT/SAMPLE_SCHEMAS/FLY1/air3.csv", 604800)
#checkcache()

