import boto3
import os

client = boto3.client('rds')

def lambda_handler(event, context):
    
    dbname = event["DbInstance"]["DbInstanceIdentifier"]
    
    response = client.describe_db_instances(
        DBInstanceIdentifier=dbname,
        )
    db_status = response["DBInstances"][0]["DBInstanceStatus"]
    return {
        'db_status': str(db_status)
        #'db_status': str(event)
        }
        


