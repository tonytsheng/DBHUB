#!/usr/bin/env python3

import boto3
import base64
import json
from botocore.exceptions import ClientError


secret_name = "arn:aws:secretsmanager:us-east-2:070201068661:secret:secret-pg102-WNHBUK"
region_name = "us-east-2"

# Create a Secrets Manager client
session = boto3.session.Session()
session = boto3.session.Session(profile_name='ec2')
client = session.client(
  service_name='secretsmanager'
    )

get_secret_value_response = client.get_secret_value(
            SecretId=secret_name
        )

print(get_secret_value_response)
database_secrets = json.loads(get_secret_value_response['SecretString'])
print(database_secrets)
print(database_secrets['password'])
