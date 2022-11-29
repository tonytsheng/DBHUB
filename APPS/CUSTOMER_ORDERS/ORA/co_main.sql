set define on 
set verify off

-- define co_password = &1
-- define connect_string = &2
-- define tbs = &3
-- define ttbs = &4

define co_password = Pass
define connect_string = ora10a
define tbs = customer_orders
define ttbs = temp

spool co_install.log

PROMPT Dropping user
@@co_drop_user

PROMPT Creating user
@@co_user &co_password &tbs &ttbs

-- conn customerorders/&co_password@&connect_string
conn customerorders/&co_password

PROMPT Running DDL
@@co_ddl

set define off

PROMPT Running DML
@@co_dml

PROMPT Example queries
@@sample_queries

spool off