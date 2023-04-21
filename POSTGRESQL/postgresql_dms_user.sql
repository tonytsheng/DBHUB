CREATE USER postgresql_dms_user WITH PASSWORD 'postgresql_dms_user'; 
ALTER USER postgresql_dms_user WITH SUPERUSER;   
grant rds_superuser to postgresql_dms_user
GRANT CONNECT ON DATABASE fly1 TO postgresql_dms_user;
GRANT USAGE ON SCHEMA fly1 TO postgresql_dms_user;
GRANT SELECT ON ALL TABLES IN SCHEMA fly1 TO postgresql_dms_user;
GRANT ALL ON SEQUENCES IN SCHEMA fly1 TO postgresql_dms_user;

             

