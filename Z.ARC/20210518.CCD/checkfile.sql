set linesize 200
SELECT * FROM TABLE(rdsadmin.rds_file_util.listdir(p_directory => 'DATA_PUMP_DIR'));
SELECT * FROM TABLE(rdsadmin.rds_file_util.read_text_file( p_directory => 'DATA_PUMP_DIR', p_filename  => 'tts_spatial_exp.log'));
exit;
