create tablespace ttsheng;

drop user TTSHENG;
create tablespace TTSHENG;
-- create user TTSHENG identified by '***' default tablespace TTSHENG;
grant create session to TTSHENG;
grant create any table to TTSHENG;
grant drop any table to TTSHENG;
grant unlimited tablespace to TTSHENG;
grant execute any procedure to TTSHENG;
grant alter any table to TTSHENG;
grant update any table to TTSHENG;
grant create any index to TTSHENG;

drop table heartbeat;

create table heartbeat 
( id int,
	last_update timestamp,
	ip_p varchar(40),
	ip_s varchar(40)
);

create index idx_heartbeat on heartbeat(id);
create sequence seq_heartbeat increment by 1 start with 1;
exit

