create tablespace uac01;
create user uac_health identified by uac_health default tablespace uac01;
grant create session to uac_health;
grant create table to uac_health;
alter user uac_health quota unlimited on uac01;


