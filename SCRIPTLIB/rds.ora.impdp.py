#!/usr/bin/python3

#----------------------------------------------------------------------------
# Created By  : Tony Sheng ttsheng@amazon.com
# Created Date: 2023-04-21
# version ='1.0'
# ---------------------------------------------------------------------------
#
# rds.ora.impdp.py
# Run an imp with an RDS for Oracle database
#   set import and log file names
#   run import job
#   wait for job to be complete
#   print out log file
#   main goal was to call apis automatically instead of manually
#
# ---------------------------------------------------------------------------
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# Ensure you apply your due diligence and test to your satisfaction
# before running this code in a Production system.
# ---------------------------------------------------------------------------
#
# To run:
# Edit your database endpoints
#    $ python3 rds.ora.impdp.py SCHEMA
# Note that the file to be imported must be in DATA_PUMP_DIR and be 
#   named SCHEMA.dmp
# Change as appropriate
#
# ---------------------------------------------------------------------------
#
# History
# 2023-04-21 - Version 1.0
# ---------------------------------------------------------------------------
#
# ToDo
#   some sort of error checking


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
#    secret_name = "arn:aws:secretsmanager:us-east-2:070201068661:secret:secret-pg102-WNHBUK"
    secret_name = "arn:aws:secretsmanager:us-east-2:070201068661:secret:pg102-secret-IZWCR2"
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
LOGFILE = SCHEMA+ ".imp.log"
DUMPFILE = SCHEMA + ".dmp"
print ("+++ Impdp logfile: " + LOGFILE)

conn = None
sql_imp = """ DECLARE  
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

    v_hdnl := DBMS_DATAPUMP.OPEN( operation => 'IMPORT', job_mode => 'SCHEMA', job_name=>'""" + SCHEMA + """_IMP'); 
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
#sql_chk_log = """ SELECT * FROM TABLE(rdsadmin.rds_file_util.read_text_file( p_directory => 'DATA_PUMP_DIR', p_filename  => '""" + LOGFILE + """')) where text like '%successfully completed%' """
sql_chk_status = """ select job_name, state from v$datapump_job where job_name = '""" + SCHEMA + """_IMP'"""

#print (sql_imp)
#print (sql_cat_log)
db_pw = get_secret()
conn = cx_Oracle.connect(user='admin'
         , password=db_pw
         , dsn='ttsora10.ciushqttrpqx.us-east-2.rds.amazonaws.com:1521/ttsora10')

cur = conn.cursor()
cur.execute(sql_imp)
time.sleep (10)

cur.execute(sql_chk_status)
records = cur.fetchall()
for row in records:
    print ("+++ Waiting for job: " + str(row))
row_count = cur.rowcount
#print(row_count)

while row_count >=1 :
    time.sleep (5)
    cur.execute(sql_chk_status)
    records = cur.fetchall()
    for row in records:
        print ("+++ Waiting for job: " + str(row))
    row_count=cur.rowcount
#    print ( row_count)

cur.execute(sql_cat_log)
records = cur.fetchall()
for row in records:
    print (row)
cur.close()




