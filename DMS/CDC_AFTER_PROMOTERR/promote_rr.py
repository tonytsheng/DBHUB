#!/usr/bin/python3

#----------------------------------------------------------------------------
# Created By  : Tony Sheng ttsheng@amazon.com
# Created Date: 2023-05-18
# version ='1.0'
# ---------------------------------------------------------------------------
#
# promote_rr.py
# Promote a Read Replica and Turn on a DMS migration task
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
#    $ python3 promote_rr.py
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

src_db=(sys.argv[1])
tgt_db=(sys.argv[2])
now = datetime.datetime.now()
print (now)
TIMESTAMP = now.strftime("%d.%m.%Y %H:%M:%S")
#LOGFILE = SCHEMA+ ".exp.log"
#DUMPFILE = SCHEMA + ".dmp"
#print ("+++ Expdp logfile: " + LOGFILE)

print (src_db)
print (tgt_db)

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
# Get SCN from source database
#
sql_get_scn = """ Select CURRENT_SCN from v$database """
cur.execute(sql_get_scn)
records = cur.fetchall()
for row in records:
    print ("+++ SCN : " + str(row))
cur.close()

#------------#------------#------------#------------#------------#------------#
# Promote Read Replica to Standalone 
#
session = boto3.session.Session()
session = boto3.session.Session(profile_name='dba')
client = session.client(
      service_name='rds'
        )
response = client.promote_read_replica(
        BackupRetentionPeriod=5,
        DBInstanceIdentifier=tgt_db,
        )
print(response)

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




