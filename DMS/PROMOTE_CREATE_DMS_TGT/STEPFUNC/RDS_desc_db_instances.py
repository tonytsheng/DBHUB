import boto3
import os

client = boto3.client('rds')

def lambda_handler(event, context):
    response = client.describe_db_instances(
        DBInstanceIdentifier='ttsora20c',
        )
    db_status = response["DBInstances"][0]["DBInstanceStatus"]
    return(db_status)


