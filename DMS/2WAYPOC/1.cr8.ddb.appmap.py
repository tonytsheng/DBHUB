import boto3

dynamodb = boto3.setup_default_session(profile_name='ec2')
dynamodb = boto3.client('dynamodb')

try:
    dynamodb.create_table(
        TableName='appmap',
        AttributeDefinitions=[
            {
                "AttributeName": "site",
                "AttributeType": "S"
            },
            {
                "AttributeName": "dbengine",
                "AttributeType": "S"
            }
        ],
        KeySchema=[
            {
                "AttributeName": "site",
                "KeyType": "HASH"
            },
            {
                "AttributeName": "dbengine",
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
