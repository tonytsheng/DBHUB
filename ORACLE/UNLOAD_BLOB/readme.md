## Unloading BLOBs using a python script
As part of modernizing to cloud databases, many customers desire to unload BLOB data from their existing databases. Ideally, these BLOB files can be put in to a highly durable and performant storage service. Instead of storing the BLOB, store a pointer to the actual content in the storage service.

This python script unloads BLOB data based on a table name, blob column name and a primary key column name. The BLOB data is saved to an individual file named by TABLE.PK.jpg. The file is then copied to an S3 bucket. After all the rows have been processed for the specified table, a list is generated from the objects in the S3 bucket. This script does not update the database table with the S3 url but that would be a logical next step. The final step would be to delete the BLOB from the row.

Edit the connection parameters and run from a compute instance that has connectivity to your database and the appropriate python libraries installed.
Examples:
```
python3 unload_blob.py TABLE_NAME BLOB_COLUMNNAME PK_COLUMNNAME
python3 unload_blob.py ORDERS ORDER_IMG ORDER_ID
```

## Unloading BLOBs from an Oracle database using stored procedures.
See files in the OLD directory.
1. For each table that you want to unload, generate a stored proc to execute the unload. You will need to include the table name, the column that holds the blob and the primary key id column name. This will create a stored proc that will unload a blob column into a file in a directory and for a single row that you will specify in the next step.
```
./gen_unloadblobproc.bsh  orders order_img order_id
```
2. Load the proc into the database.

3. Call the stored proc for the specific table and primary key identifier - 
```
exec unload_blob_orders (255825,'DATA_PUMP_DIR');
```
4. You can run step 1 for every table in your database that has a BLOB column.

5. Call the proc for every row that has BLOB data, which will generate a file that can be copied to a storage service.


