select 'alter table ' || table_name || ' add supplemental log data (all) columns;' 
from dba_tables where owner='CUSTOMER_ORDERS';

-- RDS only
exec rdsadmin.rdsadmin_util.set_configuration('archivelog retention hours',24);
exec rdsadmin.rdsadmin_util.alter_supplemental_logging('ADD');
exec rdsadmin.rdsadmin_util.alter_supplemental_logging('ADD','PRIMARY KEY');
SELECT supplemental_log_data_min FROM v$database;

