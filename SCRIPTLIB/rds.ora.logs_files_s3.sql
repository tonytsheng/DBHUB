set linesize 200
SELECT originating_timestamp || ' ' || message_text FROM alertlog;

SELECT * FROM TABLE(rdsadmin.rds_file_util.listdir(p_directory => 'DATA_PUMP_DIR'));
SELECT * FROM TABLE(rdsadmin.rds_file_util.listdir('BDUMP'));

SQL> SELECT rdsadmin.rdsadmin_s3_tasks.upload_to_s3(
  p_bucket_name    =>  'ttsheng-logs',
  p_directory_name =>  'DATA_PUMP_DIR')
AS TASK_ID FROM DUAL;
  2    3    4
TASK_ID
--------------------------------------------------------------------------------
1612382724403-645

select * from table(RDSADMIN.RDS_FILE_UTIL.LISTDIR('DATA_PUMP_DIR')) order by mtime;
SELECT * FROM TABLE(rdsadmin.rds_file_util.listdir('DATA_PUMP_DIR')) ORDER BY MTIME;

SELECT * FROM TABLE(rdsadmin.rds_file_util.listdir('DATA_PUMP_DIR')) ORDER BY MTIME;
SELECT * FROM TABLE(rdsadmin.rds_file_util.read_text_file( p_directory => 'DATA_PUMP_DIR', p_filename  => 'sample_imp.log'));

SQL> exec rdsadmin.rdsadmin_util.create_directory(p_directory_name => 'img_dir');

PL/SQL procedure successfully completed.

SQL> SELECT rdsadmin.rdsadmin_s3_tasks.upload_to_s3(
  p_bucket_name    =>  'ttsheng-ing',
  p_directory_name =>  'IMG_DIR')
AS TASK_ID FROM DUAL;
  2    3    4
TASK_ID
--------------------------------------------------------------------------------
1613232257518-54

SELECT text FROM table(rdsadmin.rds_file_util.read_text_file('BDUMP','dbtask-1613232257518-54.log'));                
            
SELECT rdsadmin.rdsadmin_s3_tasks.upload_to_s3(
  p_bucket_name    =>  'ttsheng-etl',
  p_directory_name =>  'IMG_DIR')
AS TASK_ID FROM DUAL;

SELECT text FROM table(rdsadmin.rds_file_util.read_text_file('BDUMP','dbtask-1613232476129-54.log'));                
SELECT rdsadmin.rdsadmin_s3_tasks.upload_to_s3(
  p_bucket_name    =>  'ttsheng-img',
  p_directory_name =>  'IMG_DIR')
AS TASK_ID FROM DUAL;
SELECT text FROM table(rdsadmin.rds_file_util.read_text_file('BDUMP','dbtask-1613233608059-54.log'));                

EXEC UTL_FILE.FREMOVE('DATA_PUMP_DIR','<file name>');

SELECT rdsadmin.rdsadmin_s3_tasks.download_from_s3(
  p_bucket_name    =>  'ttsheng-pgdata',
  p_directory_name =>  'DATA_PUMP_DIR')
AS TASK_ID FROM DUAL;

