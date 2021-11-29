exec rdsadmin.rdsadmin_util.create_directory(p_directory_name=>'RMAN_PUMP_DIR');
select * from table(rdsadmin.rds_file_util.listdir(p_directory=>'RMAN_PUMP_DIR'));

BEGIN
rdsadmin.rdsadmin_rman_util.backup_database_full(
p_owner=>'SYS',
p_directory_name=>'RMAN_PUMP_DIR',
p_parallel=>4,
p_section_size_mb=>50,
p_rman_to_dbms_output=>FALSE);
END;    
/

