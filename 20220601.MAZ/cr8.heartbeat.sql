drop table heartbeat;

create table heartbeat 
( id int,
	last_update timestamp,
	ip varchar(40));

create index idx_heartbeat on heartbeat(id);
create sequence seq_heartbeat increment by 1 start with 1;
exit

