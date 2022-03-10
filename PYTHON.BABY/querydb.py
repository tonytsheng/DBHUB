#!/usr/bin/python
import psycopg2
import boto3
import base64
import json
from botocore.exceptions import ClientError

def connect():
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

#    print(get_secret_value_response)
    database_secrets = json.loads(get_secret_value_response['SecretString'])
#    print(database_secrets)
#    print(database_secrets['password'])
    password = database_secrets['password']

#    Connect to the PostgreSQL database server 
    conn = None
    try:

        # connect to the PostgreSQL server
#        print('Connecting to the PostgreSQL database...')
        conn = psycopg2.connect(user="postgres"
                , password=password
                , host="pg102.cyt4dgtj55oy.us-east-2.rds.amazonaws.com"
                , port="5432"
                , database="pg102")
		
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

