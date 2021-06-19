set define on 
set verify off

-- define co_password = &1
-- define connect_string = &2
-- define tbs = &3
-- define ttbs = &4

define co_password = Pass1234
define connect_string = ttsora10
define tbs = customer_orders
define ttbs = temp

spool co_install.log

PROMPT Dropping user
@@co_drop_user

PROMPT Creating user
@@co_user &co_password &tbs &ttbs

conn customer_orders/&co_password@&connect_string

PROMPT Running DDL
@@co_ddl

set define off

PROMPT Running DML
@@co_dml

PROMPT Example queries
@@sample_queries

spool off
