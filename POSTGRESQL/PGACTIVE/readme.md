## Multi Writer Databases with RDS PostgreSQL and the pgactive Extension
Using the reference docs below, here are notes on setting up multi-writer databases across 3 RDS for PostgreSQL databases.
See:
- https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Appendix.PostgreSQL.CommonDBATasks.Extensions.html#Appendix.PostgreSQL.CommonDBATasks.pgactive
- https://aws.amazon.com/blogs/database/using-pgactive-active-active-replication-extension-for-postgresql-on-amazon-rds-for-postgresql/

## Create databases
Create 3 databases. Make sure to specify your appropriate:
- database instance identifier 
- db-subnet-group-name
- region
- availability zone
- password
```
aws rds create-db-instance  --db-name app  --db-instance-identifier pg5001  --allocated-storage 50  --db-instance-class db.m5d.large --engine postgres  --master-username postgres --master-user-password Pass  --db-subnet-group-name default-vpc-0467e5c237261df36  --availability-zone us-east-2b  --engine-version  15.4  --publicly-accessible   --enable-cloudwatch-logs-exports  postgresql  --profile ec2  --region us-east-2

aws rds create-db-instance  --db-name app  --db-instance-identifier pg5002  --allocated-storage 50  --db-instance-class db.m5d.large --engine postgres  --master-username postgres --master-user-password Pass  --db-subnet-group-name default-vpc-0467e5c237261df36  --availability-zone us-east-2b  --engine-version  15.4  --publicly-accessible   --enable-cloudwatch-logs-exports  postgresql  --profile ec2  --region us-east-2

aws rds create-db-instance  --db-name app  --db-instance-identifier pg5003  --allocated-storage 50  --db-instance-class db.m5d.large --engine postgres  --master-username postgres --master-user-password Pass  --db-subnet-group-name default-vpc-0467e5c237261df36  --availability-zone us-east-2b  --engine-version  15.4  --publicly-accessible   --enable-cloudwatch-logs-exports  postgresql  --profile ec2  --region us-east-2
```

## Create a new parameter group and change the two parameters
```aws rds create-db-parameter-group --db-parameter-group-name pg15-pgactive --db-parameter-group-family postgres15 --description "Parameter group that contains pgactive settings for PostgreSQL 15" --region us-east-2 --profile ec2

aws rds modify-db-parameter-group --db-parameter-group-name pg15-pgactive --parameters '[{"ParameterName": "rds.enable_pgactive","ParameterValue": "1","ApplyMethod": "pending-reboot"},{"ParameterName": "rds.custom_dns_resolution","ParameterValue": "1","ApplyMethod": "pending-reboot"}]' --region us-east-2 --profile ec2

aws rds modify-db-instance --db-instance-identifier pg5001 --db-parameter-group-name pg15-pgactive --profile ec2
aws rds modify-db-instance --db-instance-identifier pg5002 --db-parameter-group-name pg15-pgactive --profile ec2
aws rds modify-db-instance --db-instance-identifier pg5003 --db-parameter-group-name pg15-pgactive --profile ec2

aws rds reboot-db-instance --db-instance-identifier pg5001 --profile ec2
aws rds reboot-db-instance --db-instance-identifier pg5002 --profile ec2
aws rds reboot-db-instance --db-instance-identifier pg5003 --profile ec2
```
Create the pgactive extension on all 3 nodes.
``` 
CREATE EXTENSION pgactive;
```

## Create application tables on Node 1
Run the 0.nodeall_ddl.sql sql script on node 1.

## Create the pgactive server groups on all 3 nodes, one at a time.
Run the following scripts per node:
- On Node 1: 
```
SELECT pgactive.pgactive_create_group
  (node_name := 'endpoint1-app'
  ,node_dsn := 'host=pg5001.cyt4dgtj55oy.us-east-2.rds.amazonaws.com dbname=app port=5432 user=postgres password=Pass')
;
SELECT pgactive.pgactive_wait_for_node_ready();
```
- On Node 2: 
```
SELECT pgactive.pgactive_join_group(node_name := 'endpoint2-app'
  , node_dsn := 'host=pg5002.cyt4dgtj55oy.us-east-2.rds.amazonaws.com dbname=app port=5432 user=postgres password=Pass'
  , join_using_dsn := 'host=pg5001.cyt4dgtj55oy.us-east-2.rds.amazonaws.com dbname=app port=5432 user=postgres password=Pass');

SELECT pgactive.pgactive_wait_for_node_ready();
```
- On Node 3: 
```
SELECT pgactive.pgactive_join_group(node_name := 'endpoint3-app'
  , node_dsn := 'host=pg5003.cyt4dgtj55oy.us-east-2.rds.amazonaws.com dbname=app port=5432 user=postgres password=Pass'
  , join_using_dsn := 'host=pg5001.cyt4dgtj55oy.us-east-2.rds.amazonaws.com dbname=app port=5432 user=postgres password=Pass');

SELECT pgactive.pgactive_wait_for_node_ready();
```
## Test Replication across all 3 nodes
See the insert.products.bsh script which uses the wordlist file.

## Monitor Replication Lag
```
pg5001:5432 postgres@app=> SELECT  node_name,  last_applied_xact_id::int - last_sent_xact_id::int AS lag_xid,  last_sent_xact_at - last_applied_xact_at AS lag_time FROM pgactive.pgactive_node_slots;
   node_name   | lag_xid |     lag_time
---------------+---------+------------------
 endpoint2-app |       0 | -00:00:00.010193
 endpoint3-app |       0 | -00:00:00.010745
(2 rows)

pg5002:5432 postgres@app=> SELECT  node_name,  last_applied_xact_id::int - last_sent_xact_id::int AS lag_xid,  last_sent_xact_at - last_applied_xact_at AS lag_time FROM pgactive.pgactive_node_slots;
   node_name   | lag_xid |     lag_time
---------------+---------+------------------
 endpoint1-app |       0 | 00:00:00.009561
 endpoint3-app |       0 | -00:00:00.000734
(2 rows)

pg5003:5432 postgres@app=> SELECT  node_name,  last_applied_xact_id::int - last_sent_xact_id::int AS lag_xid,  last_sent_xact_at - last_applied_xact_at AS lag_time FROM pgactive.pgactive_node_slots;
   node_name   | lag_xid |    lag_time
---------------+---------+-----------------
 endpoint1-app |       0 | 00:00:00.009873
 endpoint2-app |       0 | 00:00:00.0003
(2 rows)
```

## Monitor Conflict Resolution
```
pg5001:5432 postgres@app=>
pg5001:5432 postgres@app=>  select conflict_id
app->   , local_conflict_time
app->   , object_schema
app->   , object_name
app->   , local_conflict_time
app->   , local_commit_time
app->   , remote_commit_time
app->   , conflict_type
app->   , local_tuple
app->   , remote_tuple
app-> from pgactive.pgactive_conflict_history;
 conflict_id | local_conflict_time | object_schema | object_name | local_conflict_time | local_commit_time | remote_commit_time | conflict_type
| local_tuple | remote_tuple
-------------+---------------------+---------------+-------------+---------------------+-------------------+--------------------+---------------
+-------------+--------------
(0 rows)

pg5002:5432 postgres@app=>  select conflict_id
app->   , local_conflict_time
app->   , object_schema
app->   , object_name
app->   , local_conflict_time
app->   , local_commit_time
app->   , remote_commit_time
app->   , conflict_type
app->   , local_tuple
app->   , remote_tuple
app-> from pgactive.pgactive_conflict_history;
 conflict_id |      local_conflict_time      | object_schema |  object_name   |      local_conflict_time      |       local_commit_time       |
     remote_commit_time       | conflict_type |
                                                                                                        local_tuple

                             |
                                                                                       remote_tuple


-------------+-------------------------------+---------------+----------------+-------------------------------+-------------------------------+-
------------------------------+---------------+-------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------+------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
------------
           1 | 2023-10-21 13:18:06.896575+00 | pgactive      | pgactive_nodes | 2023-10-21 13:18:06.896575+00 | 2023-10-21 13:18:06.814388+00 |
2023-10-21 13:18:06.802592+00 | insert_insert | {"node_sysid":"7292400423734932012","node_timeline":"0","node_dboid":"16404","node_status":"c","
node_name":"endpoint2-app","node_dsn":"host=pg5002.cyt4dgtj55oy.us-east-2.rds.amazonaws.com dbname=app port=5432 user=postgres password=Pass
","node_init_from_dsn":"host=pg5001.cyt4dgtj55oy.us-east-2.rds.amazonaws.com dbname=app port=5432 user=postgres password=Pass","node_read_on
ly":true,"node_seq_id":null} | {"node_sysid":"7292400423734932012","node_timeline":"0","node_dboid":"16404","node_status":"i","node_name":"endpo
int2-app","node_dsn":"host=pg5002.cyt4dgtj55oy.us-east-2.rds.amazonaws.com dbname=app port=5432 user=postgres password=Pass","node_init_from
_dsn":"host=pg5001.cyt4dgtj55oy.us-east-2.rds.amazonaws.com dbname=app port=5432 user=postgres password=Pass","node_read_only":true,"node_se
q_id":null}
           2 | 2023-10-21 14:02:31.299364+00 | inventory     | products       | 2023-10-21 14:02:31.299364+00 | 2023-10-21 14:02:31.297884+00 |
2023-10-21 14:02:28.792499+00 | update_update | {"id":"b917476c-a288-4ac7-b920-1cc8ab98bed3","product_name":"ORGANIC2","created_at":"2023-10-21T13:48:54.81943+00:00","site_id":"pg5002.cyt4dgtj55oy.us-east-2.rds.amazonaws.com"}

                             | {"id":"b917476c-a288-4ac7-b920-1cc8ab98bed3","product_name":"ORGANIC1","created_at":"2023-10-21T13:48:54.81943+00:00","site_id":"pg5002.cyt4dgtj55oy.us-east-2.rds.amazonaws.com"}
           3 | 2023-10-21 14:02:31.299754+00 | inventory     | products       | 2023-10-21 14:02:31.299754+00 | 2023-10-21 14:02:31.297884+00 |
2023-10-21 14:02:28.792499+00 | update_update | {"id":"c0213505-0d79-404a-98de-d9439e7ab617","product_name":"ORGANIC2","created_at":"2023-10-21T13:50:13.887644+00:00","site_id":"pg5001.cyt4dgtj55oy.us-east-2.rds.amazonaws.com"}

                             | {"id":"c0213505-0d79-404a-98de-d9439e7ab617","product_name":"ORGANIC1","created_at":"2023-10-21T13:50:13.887644+00:00","site_id":"pg5001.cyt4dgtj55oy.us-east-2.rds.amazonaws.com"}
           4 | 2023-10-21 14:02:31.29981+00  | inventory     | products       | 2023-10-21 14:02:31.29981+00  | 2023-10-21 14:02:31.297884+00 |
2023-10-21 14:02:28.792499+00 | update_update | {"id":"f13d22af-03cf-4040-a66e-1a32ecf525b9","product_name":"ORGANIC2","created_at":"2023-10-21T13:58:22.957629+00:00","site_id":"pg5003.cyt4dgtj55oy.us-east-2.rds.amazonaws.com"}

                             | {"id":"f13d22af-03cf-4040-a66e-1a32ecf525b9","product_name":"ORGANIC1","created_at":"2023-10-21T13:58:22.957629+00:00","site_id":"pg5003.cyt4dgtj55oy.us-east-2.rds.amazonaws.com"}
           5 | 2023-10-21 14:02:31.29986+00  | inventory     | products       | 2023-10-21 14:02:31.29986+00  | 2023-10-21 14:02:31.297884+00 |
2023-10-21 14:02:28.792499+00 | update_update | {"id":"7dc6a55a-f0f7-41eb-a6d0-af9dda547ab0","product_name":"ORGANIC2","created_at":"2023-10-21T13:57:09.568309+00:00","site_id":"pg5002.cyt4dgtj55oy.us-east-2.rds.amazonaws.com"}
```

## Clean Up
```
SELECT * FROM pgactive.pgactive_detach_nodes(ARRAY[‘node2-app']);
SELECT * FROM pgactive.pgactive_remove();
SELECT * FROM pgactive.pgactive_remove(true);
```

