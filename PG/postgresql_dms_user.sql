CREATE USER postgresql_dms_user WITH PASSWORD 'postgresql_dms_user'; 
ALTER USER postgresql_dms_user WITH SUPERUSER;   
grant rds_superuser to postgresql_dms_user
             

