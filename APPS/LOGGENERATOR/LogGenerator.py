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


def random_date(start, end):
    """
    This function will return a random datetime between two datetime
    objects.
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
    yy = str(randint (2010,2024))
    mm = str(randint (1,12))
    dd = str(randint (1,31))
    hh = str(randint (00,23))
    mi = str(randint (00,59))
    ss = str(randint (00,59))
    ts = (yy+mm+dd+'T'+hh+':'+mm+':'+ss)
    print (ts)

#    destData = time.strftime("/var/log/cadabra/%Y%m%d-%H%M%S.log")
    destData = time.strftime("%Y%m%d-%H%M%S.log")
    with open(sourceData, 'r', encoding='latin-1') as csvfile:
        with open(destData, 'w') as dstfile:
            reader = csv.reader(csvfile)
            writer = csv.writer(dstfile)
            next (reader) #skip header
            inputRow = 0
            linesWritten = 0
            for row in reader:
                inputRow += 1
                row.append(ts)
                print(row)
                if (inputRow > startLine):
                    writer.writerow(row)
                    linesWritten += 1
                    if (linesWritten >= numLines):
                        break
            return linesWritten
        
    
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

print("Writing " + str(numLines) + " lines starting at line " + str(startLine) + "\n")

totalLinesWritten = 0
linesInFile = GetLineCount()

while (totalLinesWritten < numLines):
    linesWritten = MakeLog(startLine, numLines - totalLinesWritten)
    totalLinesWritten += linesWritten
    startLine += linesWritten
    if (startLine >= linesInFile):
        startLine = 0
        
print("Wrote " + str(totalLinesWritten) + " lines.\n")
    
with open(placeholder, 'w') as f:
    f.write(str(startLine))
