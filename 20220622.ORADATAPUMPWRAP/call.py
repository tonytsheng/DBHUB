#!/usr/bin/python3

## export schema from schema name in parameter
## generate log file
## call schema export
## pause until complete - polling logfile
##

#import psycopg2 
import boto3
import base64
import json
import decimal
import sys
import getopt
import cx_Oracle
from botocore.exceptions import ClientError
from boto3.dynamodb.conditions import Key
from datetime import date
from datetime import datetime
import time
import datetime

def wait():
    for i in range(12):
        now = datetime.datetime.now()
        date_time = now.strftime("%d.%m.%Y %H:%M:%S")
        print(date_time)
        time.sleep (5)

def get_secret():
    secret_name = "arn:aws:secretsmanager:us-east-2:070201068661:secret:secret-pg102-WNHBUK"
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

SCHEMA=(sys.argv[1])
now = datetime.datetime.now()
TIMESTAMP = now.strftime("%d.%m.%Y %H:%M:%S")
LOGFILE = SCHEMA+ ".exp.log"
DUMPFILE = SCHEMA + ".dmp"
print (LOGFILE)

conn = None
sql_exp = """ DECLARE  
  v_hdnl NUMBER;
  ind NUMBER;              -- Loop index
  h1 NUMBER;               -- Data Pump job handle
  percent_done NUMBER;     -- Percentage of job complete
  job_state VARCHAR2(30);  -- To keep track of job state
  le ku$_LogEntry;         -- For WIP and error messages
  js ku$_JobStatus;        -- The job status from get_status
  jd ku$_JobDesc;          -- The job description from get_status
  sts ku$_Status;          -- The status object returned by get_status
BEGIN

    v_hdnl := DBMS_DATAPUMP.OPEN( operation => 'EXPORT', job_mode => 'SCHEMA', job_name=>null); 
      dbms_output.put_line (v_hdnl);
    DBMS_DATAPUMP.ADD_FILE(
      handle    => v_hdnl,
      filename  => '""" + DUMPFILE + """',
      directory => 'DATA_PUMP_DIR',
      filetype  => dbms_datapump.ku$_file_type_dump_file,
      reusefile => 1);
    DBMS_DATAPUMP.ADD_FILE(
      handle    => v_hdnl,
      filename  => '""" + LOGFILE + """',
      directory => 'DATA_PUMP_DIR',
      filetype  => dbms_datapump.ku$_file_type_log_file,
      reusefile => 1);
    dbms_output.put_line ('Post add file');
    DBMS_DATAPUMP.METADATA_FILTER(v_hdnl,'SCHEMA_EXPR','IN (''""" + SCHEMA + """'')');
    dbms_output.put_line ('Post metadata filter ');
    DBMS_DATAPUMP.START_JOB(v_hdnl);
END; """

sql_list = """ SELECT * FROM TABLE(rdsadmin.rds_file_util.listdir('DATA_PUMP_DIR')) ORDER BY MTIME """
sql_cat_log = """ SELECT * FROM TABLE(rdsadmin.rds_file_util.read_text_file( p_directory => 'DATA_PUMP_DIR', p_filename  => '""" + LOGFILE + """'))"""
sql_chk_log = """ SELECT * FROM TABLE(rdsadmin.rds_file_util.read_text_file( p_directory => 'DATA_PUMP_DIR', p_filename  => '""" + LOGFILE + """')) where text like '%successfully completed%' """

#print (sql_exp)
#print (sql_cat_log)
db_pw = get_secret()
conn = cx_Oracle.connect(user='admin'
         , password=db_pw
         , dsn='ttsora10.ciushqttrpqx.us-east-2.rds.amazonaws.com:1521/ttsora10')
cur = conn.cursor()

cur.execute(sql_exp)
#records = cur.fetchall()
#for row in records:
#    print (row)

#print ('+++ log list +++')
#cur.execute(sql_list)
#records = cur.fetchall()
#for row in records:
#    print (row)

print('+++ starting job...')
print('+++ waiting 60 seconds...')
wait()

chklogrows = cur.execute(sql_chk_log)
print (len(chklogrows))

print ('+++ log contents +++')
cur.execute(sql_cat_log)
records = cur.fetchall()
for row in records:
    print (row)
cur.close()




