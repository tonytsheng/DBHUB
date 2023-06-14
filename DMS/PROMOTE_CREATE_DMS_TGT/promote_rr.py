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
        ReplicationTaskSettings="{\"Logging\":{\"EnableLogging\":true,\"EnableLogContext\":false,\"LogComponents\":[{\"Severity\":\"LOGGER_SEVERITY_DEFAULT\",\"Id\":\"DATA_STRUCTURE\"},{\"Severity\":\"LOGGER_SEVERITY_DEFAULT\",\"Id\":\"COMMUNICATION\"},{\"Severity\":\"LOGGER_SEVERITY_DEFAULT\",\"Id\":\"IO\"},{\"Severity\":\"LOGGER_SEVERITY_DEFAULT\",\"Id\":\"COMMON\"},{\"Severity\":\"LOGGER_SEVERITY_DEFAULT\",\"Id\":\"FILE_FACTORY\"},{\"Severity\":\"LOGGER_SEVERITY_DEFAULT\",\"Id\":\"FILE_TRANSFER\"},{\"Severity\":\"LOGGER_SEVERITY_DEFAULT\",\"Id\":\"REST_SERVER\"},{\"Severity\":\"LOGGER_SEVERITY_DEFAULT\",\"Id\":\"ADDONS\"},{\"Severity\":\"LOGGER_SEVERITY_DEFAULT\",\"Id\":\"TARGET_LOAD\"},{\"Severity\":\"LOGGER_SEVERITY_DEFAULT\",\"Id\":\"TARGET_APPLY\"},{\"Severity\":\"LOGGER_SEVERITY_DEFAULT\",\"Id\":\"SOURCE_UNLOAD\"},{\"Severity\":\"LOGGER_SEVERITY_DEFAULT\",\"Id\":\"SOURCE_CAPTURE\"},{\"Severity\":\"LOGGER_SEVERITY_DEFAULT\",\"Id\":\"TRANSFORMATION\"},{\"Severity\":\"LOGGER_SEVERITY_DEFAULT\",\"Id\":\"SORTER\"},{\"Severity\":\"LOGGER_SEVERITY_DEFAULT\",\"Id\":\"TASK_MANAGER\"},{\"Severity\":\"LOGGER_SEVERITY_DEFAULT\",\"Id\":\"TABLES_MANAGER\"},{\"Severity\":\"LOGGER_SEVERITY_DEFAULT\",\"Id\":\"METADATA_MANAGER\"},{\"Severity\":\"LOGGER_SEVERITY_DEFAULT\",\"Id\":\"PERFORMANCE\"},{\"Severity\":\"LOGGER_SEVERITY_DEFAULT\",\"Id\":\"VALIDATOR_EXT\"}],\"CloudWatchLogGroup\":null,\"CloudWatchLogStream\":null},\"StreamBufferSettings\":{\"StreamBufferCount\":3,\"CtrlStreamBufferSizeInMB\":5,\"StreamBufferSizeInMB\":8},\"ErrorBehavior\":{\"FailOnNoTablesCaptured\":true,\"ApplyErrorUpdatePolicy\":\"LOG_ERROR\",\"FailOnTransactionConsistencyBreached\":false,\"RecoverableErrorThrottlingMax\":1800,\"DataErrorEscalationPolicy\":\"SUSPEND_TABLE\",\"ApplyErrorEscalationCount\":0,\"RecoverableErrorStopRetryAfterThrottlingMax\":true,\"RecoverableErrorThrottling\":true,\"ApplyErrorFailOnTruncationDdl\":false,\"DataTruncationErrorPolicy\":\"LOG_ERROR\",\"ApplyErrorInsertPolicy\":\"LOG_ERROR\",\"EventErrorPolicy\":\"IGNORE\",\"ApplyErrorEscalationPolicy\":\"LOG_ERROR\",\"RecoverableErrorCount\":-1,\"DataErrorEscalationCount\":0,\"TableErrorEscalationPolicy\":\"STOP_TASK\",\"RecoverableErrorInterval\":5,\"ApplyErrorDeletePolicy\":\"IGNORE_RECORD\",\"TableErrorEscalationCount\":0,\"FullLoadIgnoreConflicts\":true,\"DataErrorPolicy\":\"LOG_ERROR\",\"TableErrorPolicy\":\"SUSPEND_TABLE\"},\"TTSettings\":{\"TTS3Settings\":null,\"TTRecordSettings\":null,\"EnableTT\":false},\"FullLoadSettings\":{\"CommitRate\":10000,\"StopTaskCachedChangesApplied\":false,\"StopTaskCachedChangesNotApplied\":false,\"MaxFullLoadSubTasks\":8,\"TransactionConsistencyTimeout\":600,\"CreatePkAfterFullLoad\":false,\"TargetTablePrepMode\":\"DO_NOTHING\"},\"TargetMetadata\":{\"ParallelApplyBufferSize\":0,\"ParallelApplyQueuesPerThread\":0,\"ParallelApplyThreads\":0,\"TargetSchema\":\"admin\",\"InlineLobMaxSize\":0,\"ParallelLoadQueuesPerThread\":0,\"SupportLobs\":true,\"LobChunkSize\":64,\"TaskRecoveryTableEnabled\":false,\"ParallelLoadThreads\":0,\"LobMaxSize\":32,\"BatchApplyEnabled\":false,\"FullLobMode\":false,\"LimitedSizeLobMode\":true,\"LoadMaxFileSize\":0,\"ParallelLoadBufferSize\":0},\"BeforeImageSettings\":null,\"ControlTablesSettings\":{\"historyTimeslotInMinutes\":5,\"HistoryTimeslotInMinutes\":5,\"StatusTableEnabled\":false,\"SuspendedTablesTableEnabled\":false,\"HistoryTableEnabled\":false,\"ControlSchema\":\"\",\"FullLoadExceptionTableEnabled\":false},\"LoopbackPreventionSettings\":null,\"CharacterSetSettings\":null,\"FailTaskWhenCleanTaskResourceFailed\":false,\"ChangeProcessingTuning\":{\"StatementCacheSize\":50,\"CommitTimeout\":1,\"BatchApplyPreserveTransaction\":true,\"BatchApplyTimeoutMin\":1,\"BatchSplitSize\":0,\"BatchApplyTimeoutMax\":30,\"MinTransactionSize\":1000,\"MemoryKeepTime\":60,\"BatchApplyMemoryLimit\":500,\"MemoryLimitTotal\":1024},\"ChangeProcessingDdlHandlingPolicy\":{\"HandleSourceTableDropped\":true,\"HandleSourceTableTruncated\":true,\"HandleSourceTableAltered\":true},\"PostProcessingRules\":null}"
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
# will need a transformation rule [schema] for each schema on the source

table_mappings_json = {
    "rules": [
        {
            "rule-type": "selection",
            "rule-id": "1",
            "rule-name": "1",
            "object-locator": {
                "schema-name": "%",
                "table-name": "%"
            },
            "rule-action": "include"
            }, 
        {
            "rule-type": "transformation",
            "rule-id": "2",
            "rule-name": "2",
            "rule-action": "rename",
            "rule-target": "schema",
            "object-locator": {
                "schema-name": "CUSTOMER_ORDERS"
                }, 
            "value": "CUSTOMER_ORDERS" 
            }
    ]
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
logit ("Promoted RR Host : "+db_endpoint)
port_msg = "Promoted RR Port : "+str(db_port)
logit (port_msg)
logit ("Promoted RR DBName : "+db_name)
logit ("Promoted RR DBInstanceArn : "+db_arn)

dbendpt = get_database_endpt_arn(src_db,'source')
src_endpoint_arn = dbendpt["Endpoints"][0]["EndpointArn"]
logit ("Source DMS Endpoint: " +src_endpoint_arn)

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

