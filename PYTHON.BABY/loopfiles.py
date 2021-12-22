from __future__ import print_function # Python 2/3 compatibility
import boto3
import time
import csv
import sys
import string
import random
import threading
import glob

print("begin script")
files = glob.glob("/home/ec2-user/DBHUB/DYN/workshop/data/log*.csv")
for filename in files:
#    print("filename: %s" % (filename))
    with open(filename, 'r', encoding="utf-8") as csvfile:
        myreader = csv.reader(csvfile, delimiter=',')
        for row in myreader:
            newitem = {}
            newitem['host'] = row[1]
            newitem['date'] =  row[2]
            print("%s : %s %s"  % (filename, newitem['host'], newitem['date']))
print("end of file")

