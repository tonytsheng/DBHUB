#!/usr/bin/env python3
#----------------------------------------------------------------------------
# Created By  : Tony Sheng ttsheng@amazon.com
# Created Date: 2022-06-30
# version ='1.0'
# ---------------------------------------------------------------------------
#
# 1.cr8.ddb.CadabraOrders.py
# Create DynamoDB table 
#   for storing appmap data
#     get the database engine credential based on an input parameter
#     and then connect appropriately
#
# ---------------------------------------------------------------------------
#
# To run:
#    $ python3 1.cr8.ddb.CadabraOrders.py
#
# ---------------------------------------------------------------------------
#
# History
# 2022-06-30 - Version 1.0
# ---------------------------------------------------------------------------
#
# ToDo


import boto3

dynamodb = boto3.setup_default_session(profile_name='ec2', region_name='us-east-1')
dynamodb = boto3.client('dynamodb')

try:
    dynamodb.create_table(
        TableName='CadabraOrders',
        AttributeDefinitions=[
            {
                "AttributeName": "CustomerID",
                "AttributeType": "N"
            },
            {
                "AttributeName": "OrderID",
                "AttributeType": "S"
            }
        ],
           KeySchema=[
            {
                "AttributeName": "CustomerID",
                "KeyType": "HASH"
            },
            {
                "AttributeName": "OrderID",
                "KeyType": "RANGE"
            }
        ],
        ProvisionedThroughput={
            "ReadCapacityUnits": 1,
            "WriteCapacityUnits": 1
        }
    )
    print("Table created successfully.")
except Exception as e:
    print("Could not create table. Error:")
    print(e)
