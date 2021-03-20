select 'alter table ' || table_name || ' add supplemental log data (all) columns;' 
from dba_tables where owner='CUSTOMER_ORDERS';

