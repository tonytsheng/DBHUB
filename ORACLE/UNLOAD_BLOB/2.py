import cx_Oracle
import sys

TABLE=(sys.argv[1])
IMG_COLUMN=(sys.argv[2])
ID_COLUMN=(sys.argv[3])
ID_VALUE=(sys.argv[4])

#print ("table: " + TABLE)
#print ("img_column: " + IMG_COLUMN)
#print ("id_column: " + ID_COLUMN)
#print ("id_value: " + ID_VALUE)
sql = 'select ' + IMG_COLUMN + ' from ' + TABLE + ' where ' + ID_COLUMN + ' = ' + ID_VALUE 
print (sql)

imagePath = TABLE+'.'+ID_VALUE+'.'+'jpg'

#conn = cx_oracle.connect('your_connection_string')

conn = cx_Oracle.connect(user="customer_orders",
                password="Pass1234",
                dsn="ttsora10.ciushqttrpqx.us-east-2.rds.amazonaws.com:1521/ttsora10")

cursor = conn.cursor()
cursor.execute(sql)

#assuming one row of image data is returned
row = cursor.fetchone()
imageBlob = row[0]

#open a new file in binary mode
imageFile = open(imagePath,'wb')

#write the data to the file
imageFile.write(imageBlob.read())

#closing the file flushes it to disk
imageFile.close()

cursor.close()
conn.close()
