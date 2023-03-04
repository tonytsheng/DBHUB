### Create parquet files from tables in an Oracle database
1. Create the stored proc write_csv:
```
sqlplus user/pw@sid @write_csv.prc
```
2. Ensure there are the right directories that the database can write files to.
```
select * from all_directories
```
3. Call the write_csv proc for each table, noting the table, directory and output file name. Run this from a machine that has enough disk space for your csv and parquet files.
```
 exec write_csv ('SCHEMA.TABLE','CSV_DIR','table.csv');
``` 
  - See the loop_write_csv pl/sql block to generate this for every table in a given schema
4. Install everything you need for python, including pandas and pyarrow if not already installed
```
pip install pandas
pip install pyarrow
```
5. Run the csv_to_parquet python script with a tablename as the only input parameter.
```
python csv_to_parquet.py TABLENAME
```
6. The output will be TABLENAME.parquet

7. Consider downloading a parquet viewer at https://github.com/mukunku/ParquetViewer/releases

8. Tables with blob columns should probably be processed differently.
