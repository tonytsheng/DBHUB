## Using pgactive for active active RDS PostgreSQL replication
Notes on using the pgactive extension for RDS for PostgreSQL. See https://aws.amazon.com/blogs/database/using-pgactive-active-active-replication-extension-for-postgresql-on-amazon-rds-for-postgresql/
## PreReqs
- Parameter group
  - rds.enable_pgactive
  - rds.custom_dns_resolution
- Instance versions 15.4-R2

## Set up the applicaiton tables
Do this on both Node 1 and Node 2. Note that I created another table called tx to test the conflict resolution later on. See the ddl.sql, ins.employee.sql, ins.txtype.sql and insert.tx.bsh scripts for more details.
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


## Configure pgactive for Node 1
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

## Configure pgactive for Node 2
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

## Checking Servers and User Mappings
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

## Dropping Servers and User Mappings
```
app=> drop user mapping for postgres server pgactive_server_endpoint2;
DROP USER MAPPING
app=> drop server pgactive_server_endpoint2;
DROP SERVER
```

## Monitoring Replication Lag
Note this is from Node 1 -> Node 2
```
pg901:5432 postgres@app=> SELECT  node_name,  last_applied_xact_id::int - last_sent_xact_id::int AS lag_xid,  last_sent_xact_at - last_applied_xact_at AS lag_time FROM pgactive.pgactive_node_slots;
   node_name   | lag_xid |    lag_time
---------------+---------+-----------------
 endpoint2-app |       0 | 00:00:00.009459
(1 row)

pg901:5432 postgres@app=> SELECT  node_name,  last_applied_xact_id::int - last_sent_xact_id::int AS lag_xid,  last_sent_xact_at - last_applied_xact_at AS lag_time FROM pgactive.pgactive_node_slots;
   node_name   | lag_xid |    lag_time
---------------+---------+-----------------
 endpoint2-app |       0 | 00:00:00.009501
(1 row)

pg901:5432 postgres@app=> SELECT  node_name,  last_applied_xact_id::int - last_sent_xact_id::int AS lag_xid,  last_sent_xact_at - last_applied_xact_at AS lag_time FROM pgactive.pgactive_node_slots;
   node_name   | lag_xid |    lag_time
---------------+---------+-----------------
 endpoint2-app |       0 | 00:00:00.009419
(1 row)
```

## Conflict Resolution
Generating conflicting in flight transactions:
```
-- Node 1
pg901:5432 postgres@app=> begin;
BEGIN
pg901:5432 postgres@app=>* update inventory.tx set txowner='XXX' where txowner='ttsheng';
UPDATE 393
pg901:5432 postgres@app=>* commit;
COMMIT

-- Node 2
pg902:5432 postgres@app=> begin;
BEGIN
pg902:5432 postgres@app=>* update inventory.tx set txowner='YYY' where txowner='ttsheng';
UPDATE 393
pg902:5432 postgres@app=>* commit;
COMMIT
```
After you generate conflicting in flight transactions, check the pgactive_conflict_history to check what has been resolved. Note the query below is just for one single transaction that was in conflict, since the pgactive_conflict_history is organized by conflict_id.
```
pg901:5432 postgres@app=> select conflict_id
  , local_conflict_time
  , object_schema
  , object_name
  , local_conflict_time
  , local_commit_time
  , remote_commit_time
  , conflict_type
  , local_tuple
  , remote_tuple 
from pgactive.pgactive_conflict_history 
where conflict_id=379;
 conflict_id |      local_conflict_time      | object_schema | object_name |      local_conflict_time      |       local_commit_time       |      remote_commit_time       | conflict_type |
                                                                      local_tuple                                                                                        |
                                                   remote_tuple
-------------+-------------------------------+---------------+-------------+-------------------------------+-------------------------------+-------------------------------+---------------+------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------
         379 | 2023-10-18 16:00:09.756059+00 | inventory     | tx          | 2023-10-18 16:00:09.756059+00 | 2023-10-18 16:00:09.739496+00 | 2023-10-18 16:00:09.176023+00 | update_update | {"id":"c37df386-2
9f9-4ced-8d43-632391a1de2b","txtype":"upsert","txowner":"XXX","siteid":"pg902.cyt4dgtj55oy.us-east-2.rds.amazonaws.com","created_at":"2023-10-18T15:10:26.654539+00:00"} | {"id":"c37df386-29f9-4ced-8d43-6323
91a1de2b","txtype":"upsert","txowner":"YYY","siteid":"pg902.cyt4dgtj55oy.us-east-2.rds.amazonaws.com","created_at":"2023-10-18T15:10:26.654539+00:00"}
(1 row)
```



