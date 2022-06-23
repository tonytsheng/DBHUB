set verify off

create user ttsheng identified by 'ttsheng';

grant create session,
      create table,
      create sequence,
      create view,
      create procedure
  to customer_orders
  identified by '***';

alter user customer_orders default tablespace customer_orders
              quota unlimited on customer_orders;

alter user customer_orders temporary tablespace temp;

