create user demo identified by demo default tablespace users quota unlimited on users;
grant create session,connect,resource to demo;
create table demo.heartbeat ( id number(10),heartbeat_date date, AZ varchar2(5)  default '1a'); 
create table demo.heartbeat ( id number(10),heartbeat_date date, AZ varchar2(5)  default '1b'); 
ALTER TABLE demo.heartbeat ADD  CONSTRAINT pk_id unique(id);

