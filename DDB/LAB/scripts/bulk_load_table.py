import json

import boto3

dynamodb = boto3.setup_default_session(profile_name='ec2')
dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('battle-royale')

items = []

with open('/home/ec2-user/DBHUB/DYN/LAB/scripts/items.json', 'r') as f:
    for row in f:
        items.append(json.loads(row))

with table.batch_writer() as batch:
    for item in items:
        batch.put_item(Item=item)
