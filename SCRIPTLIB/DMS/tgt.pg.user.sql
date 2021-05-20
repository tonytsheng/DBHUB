create user dms_user with password 'Pass1234';
alter schema customer_orders owner to dms_user;
GRANT USAGE ON SCHEMA customer_orders TO dms_user;
GRANT CONNECT ON DATABASE postgres to dms_user;
GRANT CREATE ON DATABASE postgres TO dms_user;
GRANT CREATE ON SCHEMA customer_orders TO dms_user;
GRANT UPDATE, INSERT, SELECT, DELETE, TRUNCATE ON ALL TABLES IN SCHEMA customer_orders TO dms_user;
GRANT TRUNCATE ON customer_orders."BasicFeed" TO dms_user;

