import boto3
import os

client = boto3.client('rds')

def lambda_handler(event, context):

    response = client.promote_read_replica(
        BackupRetentionPeriod = 5,
        DBInstanceIdentifier = 'ttsora20c'
        )
        
    response = "Promoting {} to primary".format(secondary)


    return (response)

