++ PreReqs
- Parameter group
- Instance versions 15.4-R2

++
```
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
```


+ node 1
```
CREATE SERVER pgactive_server_endpoint1
    FOREIGN DATA WRAPPER pgactive_fdw
    OPTIONS (host 'pg901.cyt4dgtj55oy.us-east-2.rds.amazonaws.com', dbname 'app');
CREATE USER MAPPING FOR postgres
    SERVER pgactive_server_endpoint1
    OPTIONS (user 'postgres', password 'Pass');

-- connection info for endpoint2
CREATE SERVER pgactive_server_endpoint2
    FOREIGN DATA WRAPPER pgactive_fdw
    OPTIONS (host 'pg902.cyt4dgtj55oy.us-east-2.rds.amazonaws.com', dbname 'app');
CREATE USER MAPPING FOR postgres
    SERVER pgactive_server_node2
    OPTIONS (user 'postgres', password 'Pass');

SELECT pgactive.pgactive_create_group
  (node_name := 'endpoint1-app'
  ,node_dsn := 'host=pg901.cyt4dgtj55oy.us-east-2.rds.amazonaws.com dbname=app port=5432 user=postgres password=Pass')
;
SELECT pgactive.pgactive_wait_for_node_ready();
```

+ node 2
```
CREATE SERVER pgactive_server_endpoint1
    FOREIGN DATA WRAPPER pgactive_fdw
    OPTIONS (host 'pg901.cyt4dgtj55oy.us-east-2.rds.amazonaws.com', dbname 'app');
CREATE USER MAPPING FOR postgres
    SERVER pgactive_server_endpoint1
    OPTIONS (user 'postgres', password 'Pass');

-- connection info for endpoint2
CREATE SERVER pgactive_server_endpoint2
    FOREIGN DATA WRAPPER pgactive_fdw
    OPTIONS (host 'pg902.cyt4dgtj55oy.us-east-2.rds.amazonaws.com', dbname 'app');
CREATE USER MAPPING FOR postgres
    SERVER pgactive_server_endpoint2
    OPTIONS (user 'postgres', password 'Pass');

SELECT pgactive.pgactive_join_group(node_name := 'endpoint2-app'
  , node_dsn := 'host=pg902.cyt4dgtj55oy.us-east-2.rds.amazonaws.com dbname=app port=5432 user=postgres password=Pass'
  , join_using_dsn := 'host=pg901.cyt4dgtj55oy.us-east-2.rds.amazonaws.com dbname=app port=5432 user=postgres password=Pass');

SELECT pgactive.pgactive_wait_for_node_ready();
```

+ checking servers/user mappings
```
app=> select * from pg_user_mappings;
 umid  | srvid |          srvname          | umuser | usename  |             umoptions
-------+-------+---------------------------+--------+----------+-----------------------------------
 16680 | 16679 | pgactive_server_endpoint1 |  16397 | postgres | {user=postgres,password=Pass}
 16682 | 16681 | pgactive_server_endpoint2 |  16397 | postgres | {user=postgres,password=Pass}
(2 rows)

app=> select * from pg_foreign_server;
  oid  |          srvname          | srvowner | srvfdw | srvtype | srvversion | srvacl |                            srvopt
ions
-------+---------------------------+----------+--------+---------+------------+--------+----------------------------------
--------------------------------
 16679 | pgactive_server_endpoint1 |    16397 |  16645 |         |            |        | {host=pg500.cyt4dgtj55oy.us-east-
2.rds.amazonaws.com,dbname=app}
(1 row)
```

+ dropping user mapping
```app=> drop user mapping for postgres server pgactive_server_endpoint2;
DROP USER MAPPING
app=> drop server pgactive_server_endpoint2;
DROP SERVER
```

+ monitoring lag
```
SELECT * FROM pgactive.pgactive_node_slots;
SELECT
  node_name
  , last_applied_xact_id::int - last_sent_xact_id::int AS lag_xid
  , last_sent_xact_at - last_applied_xact_at AS lag_time
FROM pgactive.pgactive_node_slots;
```

+ monitoring conflict resolution
```
SELECT * FROM pgactive.pgactive_conflict_history;
```



