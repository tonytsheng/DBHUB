#!/usr/bin/python
# to run: python3 connect.ora.py

#import psycopg2
import cx_Oracle
import os
import socket

#from config import config

def connect():
    """ Connect to the Oracle database server """
    conn = None
    try:
        conn = cx_Oracle.connect(user="customer_orders",
                password="Pass1234",
                dsn="ttsm100.ciushqttrpqx.us-east-2.rds.amazonaws.com:1521/ttsm100")
		
        cur = conn.cursor()
        
        print('count from customer_orders.products')
        sql = "insert into heartbeat values (%s, %s, %s )"
        val = ("seq_heartbeat.nextval", "sysdate", (ip))

        print (sql)


#        cur.execute('SELECT count(*) from customer_orders.products')
        cur.execute(sql, val)
        query_out = cur.fetchone()
        print(query_out)
        print(ip)

        cur.close()
#    except (Exception, psycopg2.DatabaseError) as error:
#        print(error)
    finally:
        if conn is not None:
            conn.close()


if __name__ == '__main__':
    ip = socket.gethostbyname('ttsm100.ciushqttrpqx.us-east-2.rds.amazonaws.com')
    connect()

