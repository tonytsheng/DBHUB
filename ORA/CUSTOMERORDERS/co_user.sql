set verify off 

grant create session, 
      create table, 
      create sequence, 
      create view, 
      create procedure
  to customer_orders
  identified by "&co_password";
  
alter user customer_orders default tablespace &tbs
              quota unlimited on &tbs;

alter user customer_orders temporary tablespace &ttbs;
