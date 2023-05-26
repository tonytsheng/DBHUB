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
def test_connection(rep_arn, endpoint_arn): 
    session = boto3.session.Session()
    session = boto3.session.Session(profile_name='dba')
    client = session.client(
      service_name='dms'
        )
    response = client.test_connection(
        ReplicationInstanceArn=rep_arn,
        EndpointArn=endpoint_arn
    )
    return(response)

#------------#------------#------------#------------#------------#------------#
# get database endpoint arn
#
def get_database_endpt_arn(dbname, endpt_type):
    session = boto3.session.Session()
    session = boto3.session.Session(profile_name='dba')
    client = session.client(
      service_name='dms'
        )
    response = client.describe_endpoints(
            Filters=[
            {
                'Name': 'endpoint-id',
                'Values': [dbname]
           },
            {
                'Name': 'endpoint-type',
                'Values': [endpt_type]
            }
       ],
       MaxRecords=23,
       Marker='string'
        )
    return(response)

#------------#------------#------------#------------#------------#------------#
# describe endpoint
#
def get_endpoint_status(endpoint_arn): 
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
def create_replication_task(reptaskid, src_endpt, tgt_endpt, reparn, cdc_start):
    session = boto3.session.Session()
    session = boto3.session.Session(profile_name='dba')
    client = session.client(
      service_name='dms'
        )

    response = client.create_replication_task(
        ReplicationTaskIdentifier=reptaskid,
        SourceEndpointArn=src_endpt,
        TargetEndpointArn=tgt_endpt,
        ReplicationInstanceArn=reparn,
        MigrationType='cdc',
        TableMappings=json.dumps(table_mappings_json),
        CdcStartPosition=cdc_start,
        ReplicationTaskSettings=''
    )
    return(response)

#------------#------------#------------#------------#------------#------------#
# desc migration task
#
def describe_replication_task(reptaskid):
    session = boto3.session.Session()
    session = boto3.session.Session(profile_name='dba')
    client = session.client(
      service_name='dms'
        )

    response = client.describe_replication_tasks(
            Filters=[
                {
                'Name': 'replication-task-id',
                'Values': [reptaskid]
            },
        ])
    return(response)

#------------#------------#------------#------------#------------#------------#
# start migration task
#
def start_replication_task(reptaskid, scn):
    session = boto3.session.Session()
    session = boto3.session.Session(profile_name='dba')
    client = session.client(
      service_name='dms'
      )

    response = client.start_replication_task(
            ReplicationTaskArn=reptaskid,
            StartReplicationTaskType='start-replication',
            CdcStartPosition=scn
        )
    return(response)


#------------#------------#------------#------------#------------#------------#
# table mappings json
#
table_mappings_json = {
    "rules": [
        {
            "rule-type": "selection",
            "rule-id": "1",
            "rule-name": "1",
            "object-locator": {
                "schema-name": "CUSTOMER_ORDERS",
                "table-name": "%"
            },
            "rule-action": "include",
            "LoopbackPreventionSettings": {
                "EnableLoopbackPrevention": "true",
                "SourceSchema": "CUSTOMER_ORDERS",
                "TargetSchema": "customer_orders"
            }
        }
    ]
}
#------------#------------#------------#------------#------------#------------#
# task settings json
#

task_settings_json = {
  "TargetMetadata": {
    "TargetSchema": "",
    "SupportLobs": "true",
    "FullLobMode": "false",
    "LobChunkSize": 64,
    "LimitedSizeLobMode": "true",
    "LobMaxSize": 3200,
    "InlineLobMaxSize": 0,
    "LoadMaxFileSize": 0,
    "ParallelLoadThreads": 0,
    "ParallelLoadBufferSize":0,
    "ParallelLoadQueuesPerThread": 1,
    "ParallelApplyThreads": 0,
    "ParallelApplyBufferSize": 100,
    "ParallelApplyQueuesPerThread": 1,    
    "BatchApplyEnabled": "false",
    "TaskRecoveryTableEnabled": "false"
  },
  "FullLoadSettings": {
    "TargetTablePrepMode": "TRUNCATE",
    "CreatePkAfterFullLoad": "false",
    "StopTaskCachedChangesApplied": "false",
    "StopTaskCachedChangesNotApplied": "false",
    "MaxFullLoadSubTasks": 8,
    "TransactionConsistencyTimeout": 600,
    "CommitRate": 10000
  },
  "Logging": {
    "EnableLogging": "true",
    "LogComponents": [
      {
        "Id": "SOURCE_CAPTURE",
        "Severity": "LOGGER_SEVERITY_DEFAULT"
      },{
        "Id": "SOURCE_UNLOAD",
        "Severity": "LOGGER_SEVERITY_DEFAULT"
      },{
        "Id": "TARGET_APPLY",
        "Severity": "LOGGER_SEVERITY_DEFAULT"
      },{
        "Id": "TARGET_LOAD",
        "Severity": "LOGGER_SEVERITY_INFO"
      },{
        "Id": "TASK_MANAGER",
        "Severity": "LOGGER_SEVERITY_DEBUG"
      }
    ],
  },
  "ControlTablesSettings": {
    "ControlSchema":"",
    "HistoryTimeslotInMinutes":5,
    "HistoryTableEnabled": "false",
    "SuspendedTablesTableEnabled": "false",
    "StatusTableEnabled": "false"
  },
  "StreamBufferSettings": {
    "StreamBufferCount": 3,
    "StreamBufferSizeInMB": 8
  },
  "ChangeProcessingTuning": { 
    "BatchApplyPreserveTransaction": "true", 
    "BatchApplyTimeoutMin": 1, 
    "BatchApplyTimeoutMax": 30, 
    "BatchApplyMemoryLimit": 500, 
    "BatchSplitSize": 0, 
    "MinTransactionSize": 1000, 
    "CommitTimeout": 1, 
    "MemoryLimitTotal": 1024, 
    "MemoryKeepTime": 60, 
    "StatementCacheSize": 50 
  },
  "ChangeProcessingDdlHandlingPolicy": {
    "HandleSourceTableDropped": "true",
    "HandleSourceTableTruncated": "true",
    "HandleSourceTableAltered": "true"
  },
  "LoopbackPreventionSettings": {
    "EnableLoopbackPrevention": "true",
    "SourceSchema": "LOOP-DATA",
    "TargetSchema": "loop-data"
  },

  "CharacterSetSettings": {
    "CharacterReplacements": [ {
        "SourceCharacterCodePoint": 35,
        "TargetCharacterCodePoint": 52
      }, {
        "SourceCharacterCodePoint": 37,
        "TargetCharacterCodePoint": 103
      }
    ],
    "CharacterSetSupport": {
      "CharacterSet": "UTF16_PlatformEndian",
      "ReplaceWithCharacterCodePoint": 0
    }
  },
  "BeforeImageSettings": {
    "EnableBeforeImage": "false",
    "FieldName": "",  
    "ColumnFilter": "pk-only"
  },
  "ErrorBehavior": {
    "DataErrorPolicy": "LOG_ERROR",
    "DataTruncationErrorPolicy":"LOG_ERROR",
    "DataErrorEscalationPolicy":"SUSPEND_TABLE",
    "DataErrorEscalationCount": 50,
    "TableErrorPolicy":"SUSPEND_TABLE",
    "TableErrorEscalationPolicy":"STOP_TASK",
    "TableErrorEscalationCount": 50,
    "RecoverableErrorCount": 0,
    "RecoverableErrorInterval": 5,
    "RecoverableErrorThrottling": "true",
    "RecoverableErrorThrottlingMax": 1800,
    "ApplyErrorDeletePolicy":"IGNORE_RECORD",
    "ApplyErrorInsertPolicy":"LOG_ERROR",
    "ApplyErrorUpdatePolicy":"LOG_ERROR",
    "ApplyErrorEscalationPolicy":"LOG_ERROR",
    "ApplyErrorEscalationCount": 0,
    "FullLoadIgnoreConflicts": "true"
  },
  "ValidationSettings": {
    "EnableValidation": "true",
    "ValidationMode": "ROW_LEVEL",
    "ThreadCount": 5,
    "PartitionSize": 10000,
    "FailureMaxCount": 1000,
    "RecordFailureDelayInMinutes": 5,
    "RecordSuspendDelayInMinutes": 30,
    "MaxKeyColumnSize": 8096,
    "TableFailureMaxCount": 10000,
    "ValidationOnly": "false",
    "HandleCollationDiff": "false",
    "RecordFailureDelayLimitInMinutes": 1,
    "SkipLobColumns": "false",
    "ValidationPartialLobSize": 0,
    "ValidationQueryCdcDelaySeconds": 0
  }
}
            

#------------#------------#------------#------------#------------#------------#
# MAIN
#
rep_instance_arn="arn:aws:dms:us-east-2:012363508593:rep:D2JPCUIHZYVACQINWOBP5KC2UCAQFT2E3QZFLIA"
# ^ change this

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

scn = get_scn(src_db)
scn_msg = ("SCN : "+scn)
logit (scn_msg)

db_status = get_database_status(src_db)
src_db_status = db_status["DBInstances"][0]["DBInstanceStatus"]
src_db_arn = db_status["DBInstances"][0]["DBInstanceArn"]
db_status = get_database_status(tgt_db) 
tgt_db_status = db_status["DBInstances"][0]["DBInstanceStatus"]
tgt_db_arn = db_status["DBInstances"][0]["DBInstanceArn"]
logit (src_db + " : " + src_db_status + " : " + src_db_arn)
logit (tgt_db + " : " + tgt_db_status + " : " + tgt_db_arn)

# promote
## promote_rr = promote_read_replica(tgt_db)
## logit ("Promoting Read Replica.")
## time.sleep(60)
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
logit ("Promoted RR Host : "+db_endpoint)
port_msg = "Promoted RR Port : "+str(db_port)
logit (port_msg)
logit ("Promoted RR DBName : "+db_name)
logit ("Promoted RR DBInstanceArn : "+db_arn)

dbendpt = get_database_endpt_arn(src_db,'source')
src_endpoint_arn = dbendpt["Endpoints"][0]["EndpointArn"]
logit ("Source DMS Endpoint: " +src_endpoint_arn)
#src_endpoint_test = test_connection(rep_instance_arn, src_endpoint_arn) 
# remove ^ don't need to test src endpoint

tgt_endpoint_arn = create_endpoint(tgt_db, db_endpoint, db_port, db_name)
logit ("Created DMS endpoint for RR DBInstanceArn : "+db_arn)

tgt_endpoint_test = test_connection(rep_instance_arn, tgt_endpoint_arn) 
desc_endpt = get_endpoint_status(tgt_endpoint_arn)
logit ("Waiting for Promoted RR DMS endpoint to test successfully - current status : "+desc_endpt)
while desc_endpt != "successful": 
    desc_endpt = get_endpoint_status(tgt_endpoint_arn)
    time.sleep (30)
    logit ("Waiting for Promoted RR DMS endpoint to test successfully - current status : "+desc_endpt)

dbendpt = get_database_endpt_arn(tgt_db,'target')
tgt_endpoint_arn = dbendpt["Endpoints"][0]["EndpointArn"]
logit ("Target DMS Endpoint: " +tgt_endpoint_arn)

create_rep_task = create_replication_task('tts100', src_endpoint_arn, tgt_endpoint_arn, rep_instance_arn, scn)
logit(create_rep_task)

desc_rep_task = describe_replication_task('tts100')
rep_task_arn = desc_rep_task['ReplicationTasks'][0]['ReplicationTaskArn']
state = desc_rep_task['ReplicationTasks'][0]['Status']

while state != "ready": 
    desc_rep_task = describe_replication_task('tts100')
    state = desc_rep_task['ReplicationTasks'][0]['Status']
    time.sleep (30)
    logit ("Waiting for Replication Task to be in ready mode - current status : "+state)

start_rep_task = start_replication_task(rep_task_arn,scn)
logit (start_rep_task)
desc_rep_task = describe_replication_task('tts100')
state = desc_rep_task['ReplicationTasks'][0]['Status']

while state != "running": 
    desc_rep_task = describe_replication_task('tts100')
    state = desc_rep_task['ReplicationTasks'][0]['Status']
    time.sleep (30)
    logit ("Waiting for Replication Task to be in running mode - current status : "+state)

logit (rep_instance_arn)
logit ("Created DMS migration task and now running.")

cur.close()


