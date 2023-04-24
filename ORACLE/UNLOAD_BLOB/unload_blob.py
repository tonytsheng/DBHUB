#!/usr/bin/python3

#----------------------------------------------------------------------------
# Created By  : Tony Sheng ttsheng@amazon.com
# Created Date: 2023-04-24
# version ='1.0'
# ---------------------------------------------------------------------------
#
# unload_blob.py
# Unload a blob column to a flat file
#   Input parameters:
#   1 - TABLE
#   2 - BLOB_COLUMN that contains the blob data
#   3 - ID_COLUMN that contains the primary key for the table
#   4 - ID_VALUE the primary key value for the query - this must return one single row
# Ensure your connection string parameters are correct
# The blob data will be in a file named: TABLE.ID_COLUMN.jpg
# Ideally, you can then copy this to a Storage Service and update the database table
# with a full path to the object in the storage service.
#
# Also considering generating automation using this script:
# For each row that has a blob column:
#   [select id from table where length(blob)>1]
#   Run this using a different id_value
#
#
# ---------------------------------------------------------------------------
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# Ensure you apply your due diligence and test to your satisfaction
# before running this code in a Production system.
# ---------------------------------------------------------------------------
#
# To run:
# Edit your database endpoints
#    $ python3 unload_blob.py $TABLE $BLOB_COLUMN $PK_COLUMN $PK_VALUE
#    $ python3 unload_blob.py ORDERS ORDER_IMG ORDER_ID 206229
#
# ---------------------------------------------------------------------------
#
# History
# 2023-04-24 - Version 1.0
# ---------------------------------------------------------------------------
#
# ToDo
#   some sort of error checking

import cx_Oracle
import sys

TABLE=(sys.argv[1])
BLOB_COLUMN=(sys.argv[2])
ID_COLUMN=(sys.argv[3])
ID_VALUE=(sys.argv[4])

#print ("table: " + TABLE)
#print ("img_column: " + IMG_COLUMN)
#print ("id_column: " + ID_COLUMN)
#print ("id_value: " + ID_VALUE)
sql = 'select ' + BLOB_COLUMN + ' from ' + TABLE + ' where ' + ID_COLUMN + ' = ' + ID_VALUE 
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
