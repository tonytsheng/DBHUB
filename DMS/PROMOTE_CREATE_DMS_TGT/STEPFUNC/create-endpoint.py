import base64
import json
import decimal
import sys
import getopt
from botocore.exceptions import ClientError
from boto3.dynamodb.conditions import Key
from datetime import date
from datetime import datetime
import time
import datetime

client = boto3.client('dms')

def lambda_handler(event, context):

    response = client.create_endpoint(
        EndpointIdentifier='ttsoraX',
        EndpointType='target',
        EngineName='oracle',
        Username='admin',
        Password='Pass',
        ServerName='ttsora20.ciushqttrpqx.us-east-2.rds.amazonaws.com',
        Port=1521,
        DatabaseName='ttsora20'
        )
    
    endpt_arn=response["Endpoint"]["EndpointArn"]
    return (endpt_arn)
