drop user FLY1;
create tablespace FLY1;
create user FLY1 identified by fly1 default tablespace FLY1;
grant create session to FLY1;
grant create any table to FLY1;
grant create sequence to FLY1;
grant drop any table to FLY1;
grant unlimited tablespace to FLY1;
grant execute any procedure to FLY1;
grant alter any table to FLY1;
grant update any table to FLY1;
grant create any index to FLY1;
exit

