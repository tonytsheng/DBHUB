#!/usr/bin/python3

#----------------------------------------------------------------------------
# Created By  : Tony Sheng ttsheng@amazon.com
# Created Date: 2023-05-18
# version ='1.0'
# ---------------------------------------------------------------------------
#
# getstatus.py
# Status a series of databases between source and read replicas
#   Prereqs:
#     A running replication instancea
#     A source database and it's appropriate Read Replica
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
#   Ensure your correct database identifier ids
#    $ python3 getstatus.py
#
# ---------------------------------------------------------------------------
#
# History
# 2023-05-18 - Version 1.0
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

#------------#------------#------------#------------#------------#------------#
# Set Vars
#

#SCHEMA=(sys.argv[1])
now = datetime.datetime.now()
print ()
print (now)
TIMESTAMP = now.strftime("%d.%m.%Y %H:%M:%S")
#LOGFILE = SCHEMA+ ".exp.log"
#DUMPFILE = SCHEMA + ".dmp"
#print ("+++ Expdp logfile: " + LOGFILE)
src_db=(sys.argv[1])
tgt_db=(sys.argv[2])

#------------#------------#------------#------------#------------#------------#
# Set Connection Attributes for Source database
#
conn = None
db_pw = get_secret()
conn = cx_Oracle.connect(user='admin'
         , password=db_pw
         , dsn='ttsora10.ciushqttrpqx.us-east-2.rds.amazonaws.com:1521/ttsora10')

cur = conn.cursor()
#cur.execute(sql_exp)
#time.sleep (10)

#------------#------------#------------#------------#------------#------------#
# Get last lines of alert log
#
sql_tail_log = """ select to_char(ORIGINATING_TIMESTAMP, 'MM/DD/YYY HH24:MI:SS'), message_text from alertlog
where ORIGINATING_TIMESTAMP > sysdate-(.5/24)
"""

cur.execute(sql_tail_log)
records = cur.fetchall()
for row in records:
    print ("+++ " + str(row))

#------------#------------#------------#------------#------------#------------#
# Get RR Latency
#
sql_rr_latency = """ select sequence#
,thread#
,status
, to_char(first_time, 'MM/DD/YYYY HH24:MI:SS') FIRST
, to_char(next_time, 'MM/DD/YYYY HH24:MI:SS') NEXT
, applied
, archived
from v$archived_log
where first_time > sysdate-(.5/24)
and dest_id=2
order by sequence#
"""
## dest_id may need to be modified in the query above

cur.execute(sql_rr_latency)
records = cur.fetchall()
for row in records:
    print ("+++ Archived Log Status: " + str(row))
row_count = cur.rowcount

#------------#------------#------------#------------#------------#------------#
# Get SCN from source database
#
sql_get_scn = """ Select CURRENT_SCN from v$database """
cur.execute(sql_get_scn)
records = cur.fetchall()
for row in records:
    print ("+++ SCN : " + str(row))

#------------#------------#------------#------------#------------#------------#

#------------#------------#------------#------------#------------#------------#
# Get Statuses about Source and Promoted Read Replica
#
session = boto3.session.Session()
session = boto3.session.Session(profile_name='dba')
client = session.client(
      service_name='rds'
        )
dbs = [src_db, tgt_db]
# make this list dynamic

print ("#------------#------------#------------#------------#------------#------------#")
print ("DBIdentifier  \t Status \t MultiAZ \t ReadReplica")
for db in dbs:
    describe_db_output = client.describe_db_instances(
        DBInstanceIdentifier=db
        )
    dbstatus = str(describe_db_output['DBInstances'][0]['DBInstanceStatus'])
    multiaz = str(describe_db_output['DBInstances'][0]['MultiAZ'])
    rrstatus = str(describe_db_output['DBInstances'][0]['ReadReplicaDBInstanceIdentifiers'])
    print(db + " \t " + dbstatus + " \t " + multiaz + " \t\t " + rrstatus)


#print(row_count)
#while row_count >=1 :
#    time.sleep (5)
#    cur.execute(sql_chk_status)
#    records = cur.fetchall()
#    for row in records:
#        print ("+++ Waiting for job: " + str(row))
#    row_count=cur.rowcount
#    print ( row_count)

#cur.execute(sql_cat_log)
#records = cur.fetchall()
#for row in records:
#    print (row)



cur.close()

