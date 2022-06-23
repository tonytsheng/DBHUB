#!/usr/bin/python

# to run: python3 connect.ora.py
#import psycopg2
import cx_Oracle

#from config import config

def connect():
    """ Connect to the Oracle database server """
    conn = None
    try:
        # read connection parameters
#        params = config()

        # connect to the PostgreSQL server
#        print('Connecting to the PostgreSQL database...')
#        conn = psycopg2.connect(**params)
        conn = cx_Oracle.connect(user="customer_orders",
                password="Pass",
                dsn="ttsm100.ciushqttrpqx.us-east-2.rds.amazonaws.com:1521/ttsm100")
#                port="1521",
#                database="ttsm100")
		
        # create a cursor
        cur = conn.cursor()
        
	# execute a statement
#        print('PostgreSQL database version:')
#        print('count from countries')
#        cur.execute('SELECT * from human_resources.countries')
#        record = cur.fetchall()
#        print(record)

        print('count from customer_orders.products')
        cur.execute('SELECT count(*) from customer_orders.products')
        query_out = cur.fetchone()
        print(query_out)

#        print('version')
#        cur.execute('SELECT version()')
#        query_out = cur.fetchone()
#        print(query_out)
       
	# close the communication with the PostgreSQL
        cur.close()
#    except (Exception, psycopg2.DatabaseError) as error:
#        print(error)
    finally:
        if conn is not None:
            conn.close()
#            print('Database connection closed.')


if __name__ == '__main__':
    connect()

