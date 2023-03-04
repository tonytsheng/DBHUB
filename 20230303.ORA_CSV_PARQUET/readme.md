### Create parquet files from tables in an Oracle database
1. Create the stored proc write_csv:
```
sqlplus user/pw@sid @write_csv.prc
```
2. Ensure there are the right directories that the database can write files to.
```
select * from all_directories
```
3. Call the write_csv proc for each table. 
```
 exec write_csv ('SCHEMA.TABLE','CSV_DIR','table.csv');
``` 
  - See the loop_write_csv pl/sql block to generate this for every table in a given schema
4. Install pandas and pyarrow if not already installed
```
pip install pandas
pip install pyarrow
```
5. Run it
```
python csv_to_parquet.py TABLENAME
```
6. The output will be TABLENAME.parquet

7. Consider downloading a parquet viewer at https://github.com/mukunku/ParquetViewer/releases
