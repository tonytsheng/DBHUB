import boto3
import os

client = boto3.client('dms')

def lambda_handler(event, context):
  endpoint_arn = "arn:aws:dms:us-east-2:012363508593:endpoint:YPNH6JQBM5774M2N4J3QS5OYNEBF5N4XQ7Z3GQA"

  response = client.describe_connections(
    Filters=[
    {
      'Name': 'endpoint-arn',
      'Values': [
        endpoint_arn
      ],
    },
  ]
)

  for connection in response['Connections']:
    if connection['EndpointArn'] == endpoint_arn:
      return {
        'connection_status': connection['Status']
      }

  raise Exception('Connection status in invalid state.')

