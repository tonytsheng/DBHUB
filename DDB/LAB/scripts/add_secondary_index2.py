import boto3

dynamodb = boto3.setup_default_session(profile_name='ec2')
dynamodb = boto3.client('dynamodb')

try:
    dynamodb.update_table(
        TableName='battle-royale',
        AttributeDefinitions=[
            {
                "AttributeName": "PK",
                "AttributeType": "S"
            },
            {
                "AttributeName": "game_id",
                "AttributeType": "S"
            }
        ],
        GlobalSecondaryIndexUpdates=[
            {
                "Create": {
                    "IndexName": "UserGameIndex",
                    "KeySchema": [
                        {
                            "AttributeName": "PK",
                            "KeyType": "HASH"
                        },
                        {
                            "AttributeName": "game_id",
                            "KeyType": "RANGE"
                        }
                    ],
                    "Projection": {
                        "ProjectionType": "ALL"
                    },
                    "ProvisionedThroughput": {
                        "ReadCapacityUnits": 1,
                        "WriteCapacityUnits": 1
                    }
                }
            }
        ],
    )
    print("Table updated successfully.")
except Exception as e:
    print("Could not update table. Error:")
    print(e)
