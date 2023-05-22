#!/usr/bin/python3
#   scratch examples

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
from time import time
import time
import datetime
import logging

def wait():
    for i in range(12):
        now = datetime.datetime.now()
        date_time = now.strftime("%d.%m.%Y %H:%M:%S")
        print(date_time)
        time.sleep (5)


def logit(msg):
    print(str(now)+" : "+ str(msg))

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
    return(response)

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
# multiple input arguments
#

src_db=(sys.argv[1])
tgt_db=(sys.argv[2])
now = datetime.datetime.now()
print (now)
TIMESTAMP = now.strftime("%d.%m.%Y %H:%M:%S")
#LOGFILE = SCHEMA+ ".exp.log"
#DUMPFILE = SCHEMA + ".dmp"
#print ("+++ Expdp logfile: " + LOGFILE)

logit(src_db)

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
sql_get_scn = """ Select name, CURRENT_SCN from v$database """
cur.execute(sql_get_scn)
#records = cur.fetchall()
#for row in records:
#    print ("+++ SCN : " + str(row))
record = cur.fetchone()
scn = str(record[1])
logit ("SCN: " + scn)
#for row in records:
#    print ("+++ SCN : " + str(row))
cur.close()

#------------#------------#------------#------------#------------#------------#
# parse returned response
#
session = boto3.session.Session()
session = boto3.session.Session(profile_name='dba')
client = session.client(
      service_name='dms'
        )
#response = client.create_endpoint(
#        EndpointIdentifier='ttsora10d',
#        EndpointType='target', 
#        EngineName='oracle', 
#        Username='admin', 
#        Password='Pass1234', 
#        ServerName='ttsora10d.ciushqttrpqx.us-east-2.rds.amazonaws.com', 
#        Port=1521, 
#        DatabaseName='ttsora10'
#        )
response = {'Endpoint': {'EndpointIdentifier': 'ttsora10d', 'EndpointType': 'TARGET', 'EngineName': 'oracle', 'EngineDisplayName': 'Oracle', 'Username': 'admin', 'ServerName': 'ttsora10d.ciushqttrpqx.us-east-2.rds.amazonaws.com', 'Port': 1521, 'DatabaseName': 'ttsora10', 'Status': 'active', 'KmsKeyId': 'arn:aws:kms:us-east-2:012363508593:key/b05c8de8-e561-4676-9d0d-915e765082dd', 'EndpointArn': 'arn:aws:dms:us-east-2:012363508593:endpoint:7YF36NKWDAOVM6X6QRS4IE5YAXJ3HMNHQOKQSKY', 'SslMode': 'none', 'OracleSettings': {'ExtraArchivedLogDestIds': [], 'DatabaseName': 'ttsora10', 'Port': 1521, 'ServerName': 'ttsora10d.ciushqttrpqx.us-east-2.rds.amazonaws.com', 'Username': 'admin'}}, 'ResponseMetadata': {'RequestId': '29bdc1c2-a407-4363-a819-d0aeea0bd067', 'HTTPStatusCode': 200, 'HTTPHeaders': {'x-amzn-requestid': '29bdc1c2-a407-4363-a819-d0aeea0bd067', 'date': 'Sat, 20 May 2023 01:16:25 GMT', 'content-type': 'application/x-amz-json-1.1', 'content-length': '694'}, 'RetryAttempts': 0}}
#print(response)
endpt_arn=response["Endpoint"]["EndpointArn"]
logit(endpt_arn)
username=response["Endpoint"]["Username"]
logit(username)

#endpointstatus=describe_endpoint("arn:aws:dms:us-east-2:012363508593:endpoint:NU3L5VIOBDWI6KWTF2YJ5IKDZG7DPNI6H7Y4OOA")
#print (endpointstatus)

src_db_status = get_database_status(src_db)
db_status = src_db_status["DBInstances"][0]["DBInstanceStatus"]
db_endpoint = src_db_status["DBInstances"][0]["Endpoint"]["Address"]
db_port = src_db_status["DBInstances"][0]["Endpoint"]["Port"]
db_name = src_db_status["DBInstances"][0]["DBName"]
logit (db_status)
logit (db_port)
logit (db_name)





#rr_promote_resp = {'DBInstance': {'DBInstanceIdentifier': 'ttsora10f', 'DBInstanceClass': 'db.r5.xlarge', 'Engine': 'oracle-ee', 'DBInstanceStatus': 'available', 'MasterUsername': 'admin', 'DBName': 'TTSORA10', 'Endpoint': {'Address': 'ttsora10f.ciushqttrpqx.us-east-2.rds.amazonaws.com', 'Port': 1521, 'HostedZoneId': 'Z2XHWR1WZ565X2'}, 'AllocatedStorage': 6155, 'InstanceCreateTime': (2023, 5, 22, 1, 22, 12, 345000, ), 'PreferredBackupWindow': '03:19-03:49', 'BackupRetentionPeriod': 0, 'DBSecurityGroups': [], 'VpcSecurityGroups': [{'VpcSecurityGroupId': 'sg-09ce174e5979a7e5c', 'Status': 'active'}], 'DBParameterGroups': [{'DBParameterGroupName': 'ttsheng-oracle-ee-19', 'ParameterApplyStatus': 'in-sync'}], 'AvailabilityZone': 'us-east-2a', 'DBSubnetGroup': {'DBSubnetGroupName': 'default-vpc-0dc155aace16a70a7', 'DBSubnetGroupDescription': 'Created from the RDS Management Console', 'VpcId': 'vpc-0dc155aace16a70a7', 'SubnetGroupStatus': 'Complete', 'Subnets': [{'SubnetIdentifier': 'subnet-012cf41f2f59bb5e2', 'SubnetAvailabilityZone': {'Name': 'us-east-2c'}, 'SubnetOutpost': {}, 'SubnetStatus': 'Active'}, {'SubnetIdentifier': 'subnet-049f3da1c10794ca0', 'SubnetAvailabilityZone': {'Name': 'us-east-2a'}, 'SubnetOutpost': {}, 'SubnetStatus': 'Active'}, {'SubnetIdentifier': 'subnet-032fbba9675f5d50e', 'SubnetAvailabilityZone': {'Name': 'us-east-2c'}, 'SubnetOutpost': {}, 'SubnetStatus': 'Active'}]}, 'PreferredMaintenanceWindow': 'mon:07:19-mon:07:49', 'PendingModifiedValues': {'BackupRetentionPeriod': 5}, 'MultiAZ': False, 'EngineVersion': '19.0.0.0.ru-2023-01.rur-2023-01.r1', 'AutoMinorVersionUpgrade': True, 'ReadReplicaSourceDBInstanceIdentifier': 'ttsora10', 'ReadReplicaDBInstanceIdentifiers': [], 'ReplicaMode': 'open-read-only', 'LicenseModel': 'bring-your-own-license', 'OptionGroupMemberships': [{'OptionGroupName': 'tts-ora-ee-19', 'Status': 'in-sync'}], 'CharacterSetName': 'AL32UTF8', 'NcharCharacterSetName': 'AL16UTF16', 'PubliclyAccessible': True, 'StatusInfos': [{'StatusType': 'read replication', 'Normal': True, 'Status': 'replicating'}], 'StorageType': 'gp2', 'DbInstancePort': 0, 'StorageEncrypted': True, 'KmsKeyId': 'arn:aws:kms:us-east-2:012363508593:key/ad59594d-35d2-4122-88ec-59bd8c8e58cf', 'DbiResourceId': 'db-7AP5VHYLLVEJOZUXDBBAS7H4U4', 'CACertificateIdentifier': 'rds-ca-2019', 'DomainMemberships': [], 'CopyTagsToSnapshot': False, 'MonitoringInterval': 0, 'DBInstanceArn': 'arn:aws:rds:us-east-2:012363508593:db:ttsora10f', 'IAMDatabaseAuthenticationEnabled': False, 'PerformanceInsightsEnabled': False, 'DeletionProtection': False, 'AssociatedRoles': [], 'MaxAllocatedStorage': 9000, 'TagList': [], 'CustomerOwnedIpEnabled': False, 'BackupTarget': 'region', 'NetworkType': 'IPV4'}, 'ResponseMetadata': {'RequestId': '7c5d73be-71bd-49d2-b543-61c234eededd', 'HTTPStatusCode': 200, 'HTTPHeaders': {'x-amzn-requestid': '7c5d73be-71bd-49d2-b543-61c234eededd', 'strict-transport-security': 'max-age=31536000', 'content-type': 'text/xml', 'content-length': '123', 'date': 'Mon, 22 May 2023 01:31:29 GMT'}, 'RetryAttempts': 0}}
#rr_promote_resp = {'DBInstance': {'DBInstanceIdentifier': 'ttsora10f', 'DBInstanceClass': 'db.r5.xlarge', 'Engine': 'oracle-ee', 'DBInstanceStatus': 'available', 'MasterUsername': 'admin', 'DBName': 'TTSORA10', 'Endpoint': {'Address': 'ttsora10f.ciushqttrpqx.us-east-2.rds.amazonaws.com', 'Port': 1521, 'HostedZoneId': 'Z2XHWR1WZ565X2'}, 'AllocatedStorage': 6155, 'InstanceCreateTime': datetime.datetime(2023, 5, 22, 1, 22, 12, 345000, tzinfo=tzlocal()), 'PreferredBackupWindow': '03:19-03:49', 'BackupRetentionPeriod': 0, 'DBSecurityGroups': [], 'VpcSecurityGroups': [{'VpcSecurityGroupId': 'sg-09ce174e5979a7e5c', 'Status': 'active'}], 'DBParameterGroups': [{'DBParameterGroupName': 'ttsheng-oracle-ee-19', 'ParameterApplyStatus': 'in-sync'}], 'AvailabilityZone': 'us-east-2a', 'DBSubnetGroup': {'DBSubnetGroupName': 'default-vpc-0dc155aace16a70a7', 'DBSubnetGroupDescription': 'Created from the RDS Management Console', 'VpcId': 'vpc-0dc155aace16a70a7', 'SubnetGroupStatus': 'Complete', 'Subnets': [{'SubnetIdentifier': 'subnet-012cf41f2f59bb5e2', 'SubnetAvailabilityZone': {'Name': 'us-east-2c'}, 'SubnetOutpost': {}, 'SubnetStatus': 'Active'}, {'SubnetIdentifier': 'subnet-049f3da1c10794ca0', 'SubnetAvailabilityZone': {'Name': 'us-east-2a'}, 'SubnetOutpost': {}, 'SubnetStatus': 'Active'}, {'SubnetIdentifier': 'subnet-032fbba9675f5d50e', 'SubnetAvailabilityZone': {'Name': 'us-east-2c'}, 'SubnetOutpost': {}, 'SubnetStatus': 'Active'}]}, 'PreferredMaintenanceWindow': 'mon:07:19-mon:07:49', 'PendingModifiedValues': {'BackupRetentionPeriod': 5}, 'MultiAZ': False, 'EngineVersion': '19.0.0.0.ru-2023-01.rur-2023-01.r1', 'AutoMinorVersionUpgrade': True, 'ReadReplicaSourceDBInstanceIdentifier': 'ttsora10', 'ReadReplicaDBInstanceIdentifiers': [], 'ReplicaMode': 'open-read-only', 'LicenseModel': 'bring-your-own-license', 'OptionGroupMemberships': [{'OptionGroupName': 'tts-ora-ee-19', 'Status': 'in-sync'}], 'CharacterSetName': 'AL32UTF8', 'NcharCharacterSetName': 'AL16UTF16', 'PubliclyAccessible': True, 'StatusInfos': [{'StatusType': 'read replication', 'Normal': True, 'Status': 'replicating'}], 'StorageType': 'gp2', 'DbInstancePort': 0, 'StorageEncrypted': True, 'KmsKeyId': 'arn:aws:kms:us-east-2:012363508593:key/ad59594d-35d2-4122-88ec-59bd8c8e58cf', 'DbiResourceId': 'db-7AP5VHYLLVEJOZUXDBBAS7H4U4', 'CACertificateIdentifier': 'rds-ca-2019', 'DomainMemberships': [], 'CopyTagsToSnapshot': False, 'MonitoringInterval': 0, 'DBInstanceArn': 'arn:aws:rds:us-east-2:012363508593:db:ttsora10f', 'IAMDatabaseAuthenticationEnabled': False, 'PerformanceInsightsEnabled': False, 'DeletionProtection': False, 'AssociatedRoles': [], 'MaxAllocatedStorage': 9000, 'TagList': [], 'CustomerOwnedIpEnabled': False, 'BackupTarget': 'region', 'NetworkType': 'IPV4'}, 'ResponseMetadata': {'RequestId': '7c5d73be-71bd-49d2-b543-61c234eededd', 'HTTPStatusCode': 200, 'HTTPHeaders': {'x-amzn-requestid': '7c5d73be-71bd-49d2-b543-61c234eededd', 'strict-transport-security': 'max-age=31536000', 'content-type': 'text/xml', 'content-length': '5403', 'date': 'Mon, 22 May 2023 01:31:29 GMT'}, 'RetryAttempts': 0}}
#result = str(json.loads(rr_promote_resp))
#print (result)

#print (rr_promote_resp)

#rr_dbid=rr_promote_resp["DBInstance"]["DBInstanceIdentifier"]
#print (rr_dbid)


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




