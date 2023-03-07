### Create parquet files from tables in an Oracle database
Sometimes, there are reasons why people are interested in converting data from a table in Oracle to an Apache Parquet file. Apache Parquet is an open source, column-oriented data file format designed for efficient data storage and retrieval. It provides efficient data compression and encoding schemes with enhanced performance to handle complex data in bulk. [1]
Here are a few resources that may help for something like this.

1. Create the stored proc write_csv:
```
% sqlplus user/pw@sid @write_csv.prc
```
2. Create the directory and grant the permissions for that directory.
```
ADMIN/ttsora10> create or replace directory CSV_DIR as /data/csv_dir;
ADMIN/ttsora10> grant read, write on directory CSV_DIR to username;
```
3. Call the write_csv proc for each table, noting the table, directory and output file name. Run this from a machine that has enough disk space for your csv and parquet files.
```
ADMIN/ttsora10> exec write_csv ('TABLE','CSV_DIR','table.csv');
``` 
  - The loop_write_csv.sql block is a good example of how to dynamically generate calls for this stored procedure for a group of tables.
  - Run each of these stored proc calls stand alone as needed per table.
4. Install everything you need for python, including pandas and pyarrow if not already installed
```
% pip install pandas
% pip install pyarrow
```
5. Run the csv_to_parquet python script with a tablename as the only input parameter.
```
% python csv_to_parquet.py TABLENAME
```
6. The output will be TABLENAME.parquet

7. Consider downloading a parquet viewer at https://github.com/mukunku/ParquetViewer/releases

8. Tables with blob columns should probably be handled differently.

- For tables with millions of rows, you may need to process subsets of rows in parallelize it. See https://asktom.oracle.com/pls/apex/f?p=100:11:0::::P11_QUESTION_ID:9536328100346697722 for some ideas.

[1] - https://parquet.apache.org/
