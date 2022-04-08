create tablespace POSTGRES;
create user postgres identified by Pass1234 default tablespace POSTGRES;
grant create session to POSTGRES;
grant create any table to POSTGRES;
grant drop any table to POSTGRES;
grant unlimited tablespace to POSTGRES;
grant execute any procedure to POSTGRES;
grant alter any table to POSTGRES;
grant update any table to POSTGRES;
grant create any index to POSTGRES;
grant create session to POSTGRES;
grant create table to POSTGRES;
grant unlimited tablespace to POSTGRES;
GRANT EXECUTE ON dbms_pipe TO public;
GRANT EXECUTE ON dbms_lock TO public;
GRANT EXECUTE ON dbms_lob TO public;
GRANT EXECUTE ON dbms_utility TO public;
GRANT EXECUTE ON dbms_sql TO public;
GRANT EXECUTE ON utl_raw TO public;
grant CREATE SEQUENCE to postgres;
grant CREATE SESSION to postgres;
grant CREATE TABLE to postgres;
grant CREATE TRIGGER to postgres;
grant CREATE VIEW to postgres;
grant CREATE PROCEDURE to postgres;


