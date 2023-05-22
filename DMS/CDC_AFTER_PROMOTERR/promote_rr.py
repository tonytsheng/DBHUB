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
# 
# Disclaimer: This code is not Production ready. There is no error handling.
# ---------------------------------------------------------------------------
#
# To run:
#    $ python3 promote_rr.py src_db tgt_db
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

#------------#------------#------------#------------#------------#------------#
# logit 
#
def logit(msg):
    now = datetime.datetime.now()
    date_time = now.strftime("%Y.%m.%d %H:%M:%S")
    print(date_time+" : "+str(msg))

#------------#------------#------------#------------#------------#------------#
# wait 
#
def wait():
    for i in range(12):
        now = datetime.datetime.now()
        date_time = now.strftime("%d.%m.%Y %H:%M:%S")
        print(date_time)
        time.sleep(5)

#------------#------------#------------#------------#------------#------------#
# get_secret
#
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
# get_database_status
#
def get_database_status(dbname): 
    session = boto3.session.Session() 
    session = boto3.session.Session(profile_name='dba') 
    client = session.client( 
        service_name='rds'
        ) 
    response = client.describe_db_instances( 
        DBInstanceIdentifier=dbname,
        ) 
#    db_status = response["DBInstances"][0]["DBInstanceStatus"]
    return(response)

#------------#------------#------------#------------#------------#------------#
# Get SCN from source database
#
def get_scn(dbname):
    sql_get_scn = """ select name, CURRENT_SCN from v$database """
    cur.execute(sql_get_scn)
    record = cur.fetchone()
    scn = str(record[1])
#    print ("after get_scn call" + scn)
    return (scn)

#------------#------------#------------#------------#------------#------------#
# promote read replica
#
def promote_read_replica(dbname): 
    session = boto3.session.Session()
    session = boto3.session.Session(profile_name='dba')
    client = session.client(
        service_name='rds'
        )
    response = client.promote_read_replica(
        BackupRetentionPeriod = 5,
        DBInstanceIdentifier = dbname,
        ) 
    return(response)

#------------#------------#------------#------------#------------#------------#
# create endpoint
#
def create_endpoint(dbid, server, port, dbname): 
    session = boto3.session.Session()
    session = boto3.session.Session(profile_name='dba')
    client = session.client(
      service_name='dms'
        )
    response = client.create_endpoint(
        EndpointIdentifier=dbid,
        EndpointType='target',
        EngineName='oracle',
        Username='admin',
        Password='Pass1234',
        ServerName=server,
        Port=port,
        DatabaseName=dbname
        )
    #print(response)
    endpt_arn=response["Endpoint"]["EndpointArn"]
    return(endpt_arn)

#------------#------------#------------#------------#------------#------------#
# test endpoint
#
def test_endpoint(rep_arn, endpoint_arn): 
    session = boto3.session.Session()
    session = boto3.session.Session(profile_name='dba')
    client = session.client(
      service_name='dms'
        )
    response = client.test_endpoint(
        ReplicationInstanceArn=rep_arn,
        EndpointArn=endpoint_arn
    )
    return(response)

#------------#------------#------------#------------#------------#------------#
# describe endpoint
#
def describe_endpoint(endpoint_arn): 
    session = boto3.session.Session()
    session = boto3.session.Session(profile_name='dba')
    client = session.client(
      service_name='dms'
        )
    response = client.describe_connections(
            Filters=[
            {
                'Name': 'endpoint-arn',
                'Values': [endpoint_arn]
           },
       ],
       MaxRecords=23,
       Marker='string'
        )
    return(response["Connections"][0]["Status"])

#------------#------------#------------#------------#------------#------------#
# create migration task
#
def create_migration_task():
    client = boto3.client('dms')

    response = client.create_replication_task(
        ReplicationTaskIdentifier='string',
        SourceEndpointArn='string',
        TargetEndpointArn='string',
        ReplicationInstanceArn='string',
        MigrationType='full-load'|'cdc'|'full-load-and-cdc',
        TableMappings='string',
        ReplicationTaskSettings="{\"Logging\": {\"EnableLogging\": true}}",
    )
    return(response)


#------------#------------#------------#------------#------------#------------#
# MAIN
#

src_db=(sys.argv[1])
tgt_db=(sys.argv[2])
now = datetime.datetime.now()
TIMESTAMP = now.strftime("%d.%m.%Y %H:%M:%S")
#print (src_db)
#print (tgt_db)

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

scn = get_scn(src_db)
scn = ("SCN : "+scn)
logit (scn)

db_status = get_database_status(src_db)
src_db_status = db_status["DBInstances"][0]["DBInstanceStatus"]
db_status = get_database_status(tgt_db) 
tgt_db_status = db_status["DBInstances"][0]["DBInstanceStatus"]
logit (src_db + " : " + src_db_status)
logit (tgt_db + " : " + tgt_db_status)

# promote
promote_rr = promote_read_replica(tgt_db)
logit ("Promoting Read Replica.")
time.sleep(60)
logit ("RR promoted.")

tgt_db_status = get_database_status(tgt_db)
db_status = tgt_db_status["DBInstances"][0]["DBInstanceStatus"]
while db_status != "available": 
    tgt_db_status = get_database_status(tgt_db)
    db_status = tgt_db_status["DBInstances"][0]["DBInstanceStatus"]
    time.sleep(30)
    logit ("Waiting for RR to become available - current status:"+ db_status)

db_endpoint = tgt_db_status["DBInstances"][0]["Endpoint"]["Address"]
db_port = tgt_db_status["DBInstances"][0]["Endpoint"]["Port"]
db_name = tgt_db_status["DBInstances"][0]["DBName"]
db_arn = tgt_db_status["DBInstances"][0]["DBInstanceArn"]
logit ("Endpoint :"+db_endpoint)
logit ("Port :"+db_port)
logit ("DBName :"+db_name)
logit ("DBArn :"+db_arn)

tgt_endpoint_arn = create_endpoint(tgt_db, db_endpoint, db_port, db_name)

desc_endpt = describe_endpoint(tgt_endpoint_arn)
while desc_endpt != "successful": 
    desc_endpt = describe_endpoint(tgt_endpoint_arn)
    time.sleep (30)
    logit ("Waiting for endpoint to test successfully - current status : "+desc_endpt)

# create migration task
# using rep instance, scn, tgt_endpoint_arn
# call waiter

# cleanup

cur.close()




22.05.2023 21:44:20 : Waiting for RR to become available - current status:backing-up
22.05.2023 21:44:50 : Waiting for RR to become available - current status:available
22.05.2023 21:44:50 : Endpoint :ttsora13.ciushqttrpqx.us-east-2.rds.amazonaws.com
Traceback (most recent call last):
  File "./promote_rr.py", line 264, in <module>
    logit ("Port :"+db_port)
TypeError: can only concatenate str (not "int") to str

