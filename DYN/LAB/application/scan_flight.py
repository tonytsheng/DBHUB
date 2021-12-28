import boto3

from entities import Game
dynamodb = boto3.setup_default_session(profile_name='ec2')
dynamodb = boto3.client('dynamodb')

def scan_flight():
    resp = dynamodb.scan(
        TableName='flight',
    )

    flights = [Game(item) for item in resp['Items']]

    return games

games = scan_flight()
print("Open games:")
for game in flights:
    print(game)
