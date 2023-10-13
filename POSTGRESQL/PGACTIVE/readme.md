++ PreReqs
- Parameter group
- Instance versions 15.4-R2

++
CREATE DATABASE app;
SELECT setting ~ 'pgactive' 
FROM pg_catalog.pg_settings
WHERE name = 'shared_preload_libraries';

app=> SELECT setting ~ 'pgactive'
app-> FROM pg_catalog.pg_settings
app-> WHERE name = 'shared_preload_libraries';
 ?column?
----------
 t
(1 row)

app=> SELECT setting ~ 'pgactive'
app-> FROM pg_catalog.pg_settings
app-> WHERE name = 'shared_preload_libraries';
 ?column?
----------
 t
(1 row)

app=> CREATE SCHEMA inventory;
CREATE SCHEMA
app=>
app=> CREATE TABLE inventory.products (
app(>   id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
app(>   product_name text NOT NULL,
app(>   created_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP
app(> );
CREATE TABLE
app=>
app=> INSERT INTO inventory.products (product_name)
app-> VALUES ('soap'), ('shampoo'), ('conditioner');
INSERT 0 3
app=>
app=> select * from products;
ERROR:  relation "products" does not exist
LINE 1: select * from products;
                      ^
app=> select * from inventory.products;
                  id                  | product_name |          created_at
--------------------------------------+--------------+-------------------------------
 535e8632-87c3-4aa6-9a28-1eadc7309b86 | soap         | 2023-10-13 18:00:39.178119+00
 9d1ace38-1e2d-4615-b261-099681b08641 | shampoo      | 2023-10-13 18:00:39.178119+00
 942cf0c8-f0da-47ea-9015-0912f18206f6 | conditioner  | 2023-10-13 18:00:39.178119+00
(3 rows)

app=> CREATE EXTENSION IF NOT EXISTS pgactive;
CREATE EXTENSION
app=> CREATE SERVER pgactive_server_pg500
app->     FOREIGN DATA WRAPPER pgactive_fdw
app->     OPTIONS (host 'pg500.cyt4dgtj55oy.us-east-2.rds.amazonaws.com', dbname 'app');
CREATE SERVER
app=> CREATE USER MAPPING FOR postgres
app->     SERVER pgactive_server_pg500
app->     OPTIONS (user 'postgres', password 'Pass1234');
CREATE USER MAPPING
app=>
app=>
app=>
app=>
app=> CREATE SERVER pgactive_server_pg600
app->     FOREIGN DATA WRAPPER pgactive_fdw
app->     OPTIONS (host 'pg600.cyt4dgtj55oy.us-east-2.rds.amazonaws.com', dbname 'app');
CREATE SERVER
app=> CREATE USER MAPPING FOR postgres
app->     SERVER pgactive_server_pg600
app->     OPTIONS (user 'postgres', password 'Pass1234');
CREATE USER MAPPING

-- run this on node 1 for node 1 credentials
SELECT pgactive.pgactive_create_group(
    node_name := 'pg500-app',
    node_dsn := 'user_mapping=postgres pgactive_foreign_server=pgactive_server_pg500'
    join_using_dsn := 'user_mapping=postgres pgactive_foreign_server=pgactive_server_endpoint1
);

SELECT pgactive.pgactive_wait_for_node_ready();


CREATE SERVER pgactive_server_endpoint1
    FOREIGN DATA WRAPPER pgactive_fdw
    OPTIONS (host 'pg500.cyt4dgtj55oy.us-east-2.rds.amazonaws.com', dbname 'app');
CREATE USER MAPPING FOR postgres
    SERVER pgactive_server_endpoint1
    OPTIONS (user 'postgres', password 'Pass1234');

-- connection info for endpoint2
CREATE SERVER pgactive_server_endpoint2
    FOREIGN DATA WRAPPER pgactive_fdw
    OPTIONS (host 'pg600.cyt4dgtj55oy.us-east-2.rds.amazonaws.com', dbname 'app');
CREATE USER MAPPING FOR postgres
    SERVER pgactive_server_endpoint2
    OPTIONS (user 'postgres', password 'Pass1234');

SELECT pgactive.pgactive_create_group(
    node_name := 'endpoint1-app',
    node_dsn := 'user_mapping=postgres pgactive_foreign_server=pgactive_server_endpoint1'
--    ,join_using_dsn := 'user_mapping=postgres pgactive_foreign_server=pgactive_server_endpoint2'
);
SELECT pgactive.pgactive_wait_for_node_ready();


SELECT pgactive.pgactive_create_group(
    node_name := 'endpoint2-app',
    node_dsn := 'user_mapping=postgres pgactive_foreign_server=pgactive_server_endpoint2'
    join_using_dsn := 'user_mapping=postgres pgactive_foreign_server=pgactive_server_endpoint1'
);
