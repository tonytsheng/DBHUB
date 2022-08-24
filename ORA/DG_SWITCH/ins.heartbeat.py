#!/usr/bin/env python3
#----------------------------------------------------------------------------
# Created By  : Tony Sheng ttsheng@amazon.com  
# Created Date: 2022-06-29
# version ='1.0'
# ---------------------------------------------------------------------------
#
# ora.testmazfailover.py
# Test Multi AZ Failover by
#   querying for database name
#   getting IP for database endpoint
#   getting status of database
#   output of all of this one line
#
# ---------------------------------------------------------------------------
#
# To run:
# Edit your database endpoints
#    $ python3 ora.testmazfailover.py
# Alternatively, run this within a while loop:
#    $ while true;do;python3 ora.testmazfailover.py;sleep 1;done
# It also may help to pipe the output to a logfile
#
# ---------------------------------------------------------------------------
# 
# History
# 2022-06-29 - Version 1.0
# ---------------------------------------------------------------------------
#
# ToDo

#import psycopg2
import cx_Oracle
import os
import socket
import datetime
#from config import config
import boto3
import json
import subprocess
from subprocess import Popen, PIPE


def db_ins(dsn, ip_p, ip_s):
    db_pw="Pass1234"
    try:
        conn = cx_Oracle.connect(user="ttsheng",
            password=db_pw,
            dsn="(DESCRIPTION=(CONNECT_TIMEOUT=10)(ADDRESS=(PROTOCOL=TCP)(HOST=" + dsn + ".ciushqttrpqx.us-east-2.rds.amazonaws.com)(PORT=1521))(CONNECT_DATA=(SID=ttsora90)))" 
            )
#        print(dsn)
        sql = "insert into heartbeat (last_update, ip_p, ip_s) values (sysdate, '" +  ip_p + "', '" + ip_s + "')" 
        cur = conn.cursor()
        cur.execute(sql)
        conn.commit()
#        records = cur.fetchone()
#        records = cur.fetchone()
#        if records: 
#            return records
#        else:                           # this block returns right away on database conn error
#            print("Database Error ")
#            return False
        cur.close()
    except cx_Oracle.DatabaseError as e:
        print("Database Error ::: ", e)
        return False


if __name__ == '__main__':
    dsn =  "ttsora90"
    dsn_s =  "ttsora90-rr"
    timestamp = str(datetime.datetime.now())
    ip_p = socket.gethostbyname('ttsora90.ciushqttrpqx.us-east-2.rds.amazonaws.com')
    ip_s = socket.gethostbyname('ttsora90-rr.ciushqttrpqx.us-east-2.rds.amazonaws.com')
    instance_stat = subprocess.run(['/usr/bin/aws rds describe-db-instances --profile dba --db-instance-identifier ttsora90 | jq -jr \' .DBInstances[] | .DBInstanceStatus \' ' ], shell=True, text=True, stdout=PIPE)
    instance_stat_s = subprocess.run(['/usr/bin/aws rds describe-db-instances --profile dba --db-instance-identifier ttsora90-rr | jq -jr \' .DBInstances[] | .DBInstanceStatus \' ' ], shell=True, text=True, stdout=PIPE)
    instance_status = instance_stat.stdout
    instance_status_s = instance_stat_s.stdout
    dbcheck = str(db_ins(dsn, ip_p, ip_s))
    dbcheck_s = str(db_ins(dsn_s, ip_p, ip_s))
    print (timestamp + " ::: " + dsn + " ::: " + ip_p + " ::: " + instance_status + " ::: " + dbcheck)
    print (timestamp + " ::: " + dsn_s + " ::: " + ip_s + " ::: " + instance_status_s + " ::: " + dbcheck_s)

