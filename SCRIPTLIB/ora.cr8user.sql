drop user DMSUSER;
create tablespace DMSUSER;
create user DMSUSER identified by Pass1234 default tablespace DMSUSER;
grant create session to DMSUSER;
grant create any table to DMSUSER;
grant drop any table to DMSUSER;
grant unlimited tablespace to DMSUSER;
grant execute any procedure to DMSUSER;
grant alter any table to DMSUSER;
grant update any table to DMSUSER;
grant create any index to DMSUSER;

