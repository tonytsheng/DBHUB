-- need to make sure your rds instance has an S3_INTEGRATION feature in the IAM role assigned to the instance
SELECT rdsadmin.rdsadmin_s3_tasks.upload_to_s3(
  p_bucket_name    =>  'ttsheng-logs',       
  p_directory_name =>  'DATA_PUMP_DIR') 
AS TASK_ID FROM DUAL;

