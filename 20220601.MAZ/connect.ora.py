#!/usr/bin/python
# to run: python3 connect.ora.py

#import psycopg2
import cx_Oracle
import os
import socket
import datetime
#from config import config

def execute():
    """ Connect to the Oracle database server """
    conn = None
    try:
        conn = cx_Oracle.connect(user="customer_orders",
                password="Pass1234",
                dsn="ttsm100.ciushqttrpqx.us-east-2.rds.amazonaws.com:1521/ttsm100")
		
        cur = conn.cursor()
        sql = "insert into heartbeat values (seq_heartbeat.nextval, :updatedate, :ip)"
        cur.execute(sql, updatedate=datetime.datetime.now(), ip=(ip))
        cur.close()
        conn.commit()
        print ("insert ::: ", ip)

    except (Exception, cx_Oracle.DatabaseError) as error:
        print("Database Error ::: ", error)
    finally:
        if conn is not None:
            conn.close()

def connect():
    dsn = "(DESCRIPTION=(CONNECT_TIMEOUT=10)(ADDRESS=(PROTOCOL=TCP)(HOST=ttsm100.ciushqttrpqx.us-east-2.rds.amazonaws.com)(PORT=1521))(CONNECT_DATA=(SID=ttsm100)))"
    try:
        conn = cx_Oracle.connect(user="customer_orders",
            password="Pass1234",
            dsn=dsn)
#            dsn="ttsm100.ciushqttrpqx.us-east-2.rds.amazonaws.com:1521/ttsm100")
    except cx_Oracle.DatabaseError as e:
            # Log error as appropriate
        raise

        # If the database connection succeeded create the cursor
        # we-re going to use.


if __name__ == '__main__':
    ip = socket.gethostbyname('ttsm100.ciushqttrpqx.us-east-2.rds.amazonaws.com')
    print (datetime.datetime.now())
    connect()

