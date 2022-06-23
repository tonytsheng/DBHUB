#!/usr/bin/python
import psycopg2
#from config import config

def connect():
    """ Connect to the PostgreSQL database server """
    conn = None
    try:
        # read connection parameters
#        params = config()

        # connect to the PostgreSQL server
#        print('Connecting to the PostgreSQL database...')
#        conn = psycopg2.connect(**params)
        conn = psycopg2.connect(user="postgres",
                password="Pass",
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

