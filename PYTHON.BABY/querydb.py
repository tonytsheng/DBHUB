#!/usr/bin/python
import psycopg2
import boto3
import base64
import json
from botocore.exceptions import ClientError


def get_secret():

    secret_name = "arn:aws:secretsmanager:us-east-2:070201068661:secret:secret-pg102-WNHBUK"
    region_name = "us-east-2"

    # Create a Secrets Manager client
    session = boto3.session.Session()
    client = session.client(
        service_name='secretsmanager',
        region_name=region_name
    )

    # In this sample we only handle the specific exceptions for the 'GetSecretValue' API.
    # See https://docs.aws.amazon.com/secretsmanager/latest/apireference/API_GetSecretValue.html
    # We rethrow the exception by default.

    try:
        get_secret_value_response = client.get_secret_value(
            SecretId=secret_name
        )
    except ClientError as e:
        if e.response['Error']['Code'] == 'DecryptionFailureException':
            # Secrets Manager can't decrypt the protected secret text using the provided KMS key.
            # Deal with the exception here, and/or rethrow at your discretion.
            raise e
        elif e.response['Error']['Code'] == 'InternalServiceErrorException':
            # An error occurred on the server side.
            # Deal with the exception here, and/or rethrow at your discretion.
            raise e
        elif e.response['Error']['Code'] == 'InvalidParameterException':
            # You provided an invalid value for a parameter.
            # Deal with the exception here, and/or rethrow at your discretion.
            raise e
        elif e.response['Error']['Code'] == 'InvalidRequestException':
            # You provided a parameter value that is not valid for the current state of the resource.
            # Deal with the exception here, and/or rethrow at your discretion.
            raise e
        elif e.response['Error']['Code'] == 'ResourceNotFoundException':
            # We can't find the resource that you asked for.
            # Deal with the exception here, and/or rethrow at your discretion.
            raise e
    else:
        # Decrypts secret using the associated KMS key.
        # Depending on whether the secret is a string or binary, one of these fields will be populated.
        if 'SecretString' in get_secret_value_response:
            secret = get_secret_value_response['SecretString']
        else:
            decoded_binary_secret = base64.b64decode(get_secret_value_response['SecretBinary'])

    # Your code goes here.


def connect():
    secret_name = "arn:aws:secretsmanager:us-east-2:070201068661:secret:secret-pg102-WNHBUK"
    region_name = "us-east-2"

    # Create a Secrets Manager client

    boto_args = {'service_name': 'secretsmanager'
            , "region_name" : region_name
            , "secret_name" : secret_name
    }

#    secretsmanager = boto3.setup_default_session(profile_name='ec2')
    # ttsheng need above for custom profile
    secretsmanager = boto3.resource(**boto_args)

    session = boto3.Session(profile_name='ec2')
    session = boto3.session.Session()
    client = session.client(
        service_name='secretsmanager',
        region_name=region_name
    )

    get_secret_value_response = client.get_secret_value(
      SecretId=secret_name
    )
    pw = json.loads(get_secret_value_response['SecretString'])
    print (pw['password'])

#    """ Connect to the PostgreSQL database server """
    conn = None
    try:

        # connect to the PostgreSQL server
#        print('Connecting to the PostgreSQL database...')
        conn = psycopg2.connect(user="postgres",
                password="Pass1234",
                host="pg102.cyt4dgtj55oy.us-east-2.rds.amazonaws.com",
                port="5432",
                database="pg102")
		
        # create a cursor
        cur = conn.cursor()
        
	# execute a statement
#        print('PostgreSQL database version:')
        print('count from countries')
        cur.execute('SELECT * from human_resources.countries')
        record = cur.fetchall()
        print(record)

        print('count from customer_orders.products')
        cur.execute('SELECT count(*) from customer_orders.products')
        query_out = cur.fetchone()
        print(query_out)

        print('version')
        cur.execute('SELECT version()')
        query_out = cur.fetchone()
        print(query_out)
       
	# close the communication with the PostgreSQL
        cur.close()
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
    finally:
        if conn is not None:
            conn.close()
#            print('Database connection closed.')


if __name__ == '__main__':
    connect()

