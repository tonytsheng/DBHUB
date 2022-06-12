drop table heartbeat;
create table heartbeat (
  heartbeat_id          integer,
  description             varchar(40) ,
  last_update_dt            timestamp ,
  last_update_site     varchar(5));
CREATE SEQUENCE seq_heartbeat INCREMENT BY 1 START WITH 100;
create unique index idxu_heartbeat on heartbeat(heartbeat_id);
exit

