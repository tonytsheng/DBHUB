drop user customer_orders;
create user customer_orders identified by 'Pass1234' default tablespace customer_orders_enc;
grant create table to customer_orders;
grant create any sequence to customer_orders;
grant create any view to customer_orders;
grant create session to customer_orders;
grant unlimited tablespace to customer_orders;

