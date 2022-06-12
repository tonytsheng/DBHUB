drop table customer_orders.heartbeat;
create table customer_orders.heartbeat (
  heartbeat_id          integer,
  description             varchar(40) ,
  last_update_dt            timestamp ,
  last_update_site     varchar(5));
CREATE SEQUENCE customer_orders.seq_heartbeat INCREMENT 1 START 100;
create unique index idxu_heartbeat on customer_orders.heartbeat(heartbeat_id);
\q

