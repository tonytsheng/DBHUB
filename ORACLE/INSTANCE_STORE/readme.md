1. Create the instance - note the instance sizes that have instance stores available.
![Optional Text](instance_store_01.jpg)

2. Create a parameter group that has the rds.instance_store_temp_size set.

3. Assign the instance to the parameter group. Reboot the instance. Ensure the parameter group is in sync.

4. Check temp data files.
```
ADMIN/ttsora90> select file_name, tablespace_name from dba_temp_files;

FILE_NAME
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
TABLESPACE_NAME
------------------------------
/rdsdbdata/db/TTSORA90_A/datafile/o1_mf_temp_lqgn0v31_.tmp
TEMP
```
5. Create a temp instance store. 
```
EXEC rdsadmin.rdsadmin_util.create_inst_store_tmp_tblspace(p_tablespace_name => 'temp01');
```
6. Alter the default temp tablespace to the tablespace that was just created.
```
EXEC rdsadmin.rdsadmin_util.alter_default_temp_tablespace(tablespace_name => 'temp01');
```
7. Check temp data files again.






https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_Oracle.advanced-features.instance-store.html



