#!/usr/bin/python3

# -*- coding: utf-8 -*-
"""
Created on Mon Feb  4 12:01:21 2019

@author: Frank
"""

import csv
import time
import sys
import datetime
import random
import pandas as pd
from random import randrange
from datetime import timedelta
from random import randint
import json
from csv import reader
from datetime import datetime

def random_date(start, end):
    """
    This function will return a random datetime between two datetime
    objects
    """
    delta = end - start
    int_delta = (delta.days * 24 * 60 * 60) + delta.seconds
    random_second = randrange(int_delta)
    return start + timedelta(seconds=random_second)

sourceData = "/home/ec2-user/data/LogGenerator/OnlineRetail_nodates.csv"
placeholder = "/home/ec2-user/data/LogGenerator/LastLine.txt"

def GetLineCount():
    with open(sourceData, encoding='latin-1') as f:
        for i, l in enumerate(f):
            pass
    return i

def MakeLog(startLine, numLines):
#    destData = time.strftime("/var/log/cadabra/%Y%m%d-%H%M%S.log")
#    destData = time.strftime("%Y%m%d-%H%M%S.log")
    destData = "infile"
    with open(sourceData, 'r', encoding='latin-1') as csvfile:
        with open(destData, 'w') as dstfile:
            reader = csv.reader(csvfile)
            writer = csv.writer(dstfile)
            next (reader) #skip header
            inputRow = 0
            linesWritten = 0
            for row in reader:
                inputRow += 1
#                row.append(ts)
#                print(row)
                if (inputRow > startLine):
                    writer.writerow(row)
                    linesWritten += 1
                    if (linesWritten >= numLines):
                        break
            return linesWritten
        
    
destData = "infile"
numLines = 50
startLine = 0            
if (len(sys.argv) > 1):
    numLines = int(sys.argv[1])
    
try:
    with open(placeholder, 'r') as f:
        for line in f:
             startLine = int(line)
except IOError:
    startLine = 0

#print("Writing " + str(numLines) + " lines starting at line " + str(startLine) + "\n")

totalLinesWritten = 0
linesInFile = GetLineCount()

while (totalLinesWritten < numLines):
    linesWritten = MakeLog(startLine, numLines - totalLinesWritten)
    totalLinesWritten += linesWritten
    startLine += linesWritten
    if (startLine >= linesInFile):
        startLine = 0
        
#print("Wrote " + str(totalLinesWritten) + " lines.\n")
    
with open(placeholder, 'w') as f:
    f.write(str(startLine))

OUTFILE="file.json"
# change in and out file
csvfile = open(destData, 'r')
jsonfile = open(OUTFILE, 'w')

count=1
# modify index count as needed

#fieldnames = ("InvoiceNo","StockCode","Description","Quantity","UnitPrice","CustomerID","Country","Timestamp")
fieldnames = ("InvoiceNo","StockCode","Description","Quantity","UnitPrice","CustomerID","Country")
# field names to match input file

reader = csv.DictReader( csvfile, fieldnames)
#reader = csv.Reader(csvfile, fieldnames)
for row in reader:
    yy = str(randint (2010,2024))
    mm = str(randint (10,12))
    dd = str(randint (10,31))
    hh = str(randint (00,23))
    mi = str(randint (00,59))
    ss = str(randint (00,59))
    ts = (yy+"-"+mm+"-"+dd+'T'+hh+':'+mm)
    jsonfile.write("{\"index\" : { \"_index\" : \"logger\", \"_id\" : " + str(count) + "}}\n")
    # change third field to match your OS index name
    print(row)
#    row.insert(0, ts)
    json.dump(row, jsonfile)
    jsonfile.write('\n')
    count += 1

d1 = datetime.strptime('2008-01-01T23:30', '%Y-%m-%dT%H:%M')
d2 = datetime.strptime('2020-01-01T23:30', '%Y-%m-%dT%H:%M')
d3=(random_date(d1, d2))
#print(random_date(d1, d2))
print (datetime.strftime(d3, '%Y-%m-%dT%H:%M'))

