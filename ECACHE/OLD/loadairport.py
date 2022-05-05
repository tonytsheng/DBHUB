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
                newitem = {}
#               should look like iata:CDG
                keyName= "iata:"+ row[1]
                keyValues={'airport_name':row[0], 'iata':row[1]}
                logging.info("%s %s"  % (keyName, keyValues))
                cache.hset(keyName, mapping=keyValues)
                cache.expire(keyName, 604800)
    logging.info("cache load done")


def checkcache ():
    #keyValues=cache.hgetall()
    keyValues=cache.keys("*")
#    logging.info("checking cache ")
    for k in enumerate(keyValues):
        logging.info("cache check {} ".format(k))


def getIdFromCache (iata):
#    logging.info("cache: %s", id)
#    keyValues=cache.keys(id)
    keyValues=cache.hgetall(iata)

    if keyValues:
        logging.info("cache hit")

    for k in enumerate(keyValues):
        logging.info("cache check {} ".format(k))


def getIdFromDB (id):

    logging.info("db: %s", id)

## main
logging.basicConfig(level=logging.INFO,format='%(asctime)s: %(message)s', datefmt='%m/%d/%Y %H:%M:%S ')

# Initialize the cache
ttl = 10
redis_url = 'redis://ttsecnew.26vdzn.ng.0001.use2.cache.amazonaws.com:6379'
cache = redis.Redis.from_url(redis_url)

loadcache("/home/ec2-user/DBHUB/BASEDAT/SAMPLE_SCHEMAS/FLY1/air2.csv", 604800)
checkcache()

getIdFromCache('CDG')
#getIdFromDB('CDG')
