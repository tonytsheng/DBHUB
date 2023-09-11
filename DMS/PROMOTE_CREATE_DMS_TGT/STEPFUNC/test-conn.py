import json
import boto3
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

    response = client.describe_connections(
            Filters=[
            {
                'Name': 'endpoint-arn',
                'Values': ['arn:aws:dms:us-east-2:012363508593:endpoint:7QWH7DU2Z4V42YR2JB7BEVSP7MJSMML743UNVIA']
           },
       ],
       MaxRecords=23,
       Marker='string'
        )

    return {
        'statusCode': 200,
        'body': response["Connections"][0]["Status"]
    
    }

