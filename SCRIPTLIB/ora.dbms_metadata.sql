set heading off;
set echo off;
set lines 1000 pages 4000
set long 999999
SELECT dbms_metadata.get_ddl('USER',UPPER('&&uname')) FROM dual;
SELECT DBMS_METADATA.GET_GRANTED_DDL('SYSTEM_GRANT',UPPER('&&uname')) from dual;
SELECT DBMS_METADATA.GET_GRANTED_DDL('ROLE_GRANT',UPPER('&&uname')) from dual;
SELECT DBMS_METADATA.GET_GRANTED_DDL('OBJECT_GRANT',UPPER('&&uname')) from dual;


