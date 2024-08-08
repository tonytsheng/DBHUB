# Native PostgreSQL replication between an RDS instance and a self managed database
Notes for a solution to replicate data using native PostgreSQL replication from an RDS instance to a self managed PostgreSQL instance. See references here:
https://repost.aws/knowledge-center/rds-postgresql-use-logical-replication

PostgreSQL uses a publication-subscription model so on the source database, you will create a publication and on the target you will subscribe to this publication.

1. Build a self managed PostgreSQL database running on an EC2 instance for your target.
See https://hbayraktar.medium.com/how-to-install-postgresql-15-on-amazon-linux-2023-a-step-by-step-guide-57eebb7ad9fc
Once your EC2 machine has been configured:
```
% sudo -i -u postgres psql
CREATE USER ttsheng WITH PASSWORD 'password';
CREATE DATABASE pg900;
GRANT ALL PRIVILEGES ON DATABASE pg900 TO ttsheng;
\c pg900 postgres
grant all on schema public to ttsheng;

#login as ttsheng
psql -h localhost -U ttsheng -d pg900
pg900=> create table t1 (col1 int);
CREATE TABLE
```
  - ensure you can connect from outside the local host
```
[ec2-user@ip-10-0-0-92 ~]$ psql -h ec2-18-222-129-83.us-east-2.compute.amazonaws.com -U ttsheng -d pg900
Password for user ttsheng:
psql (15.7)
Type "help" for help.

pg900=> \dt
        List of relations
 Schema | Name | Type  |  Owner
--------+------+-------+---------
 public | t1   | table | ttsheng
(1 row)

pg900=> \q
```

2. Configure your RDS for Postgresql database for replication.
- Modify your custom parameter group setting rds.logical_replication to 1.  Confirm this is correct.
```
pg102=> SELECT name,setting FROM pg_settings WHERE name IN ('wal_level','rds.logical_replication');
          name           | setting
-------------------------+---------
 rds.logical_replication | on
 wal_level               | logical
(2 rows)
```

3. Create test replication tables on the source and target. Create them in the public schema at least for testing.
```
pg102=> CREATE TABLE public.reptab1 (slno int primary key);
CREATE TABLE
pg102=> CREATE TABLE public.reptab2 (name varchar(20));
CREATE TABLE
```

4. Load data into the source tables.
pg102=> INSERT INTO public.reptab1 VALUES (generate_series(1,1000));
INSERT 0 1000
pg102=> INSERT INTO public.reptab2 SELECT SUBSTR ('ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789',((random()*(36-1)+1)::integer),1) FROM generate_series(1,50);
INSERT 0 50
pg102=> select count(*) from public.reptab1;
 count
-------
  1000
(1 row)

5. Create a publication on the source database.
```
pg102=> CREATE PUBLICATION testpub FOR TABLE public.reptab1, public.reptab2;
CREATE PUBLICATION
pg102=> select * from pg_publication;
   oid    | pubname | pubowner | puballtables | pubinsert | pubupdate | pubdelete | pubtruncate
----------+---------+----------+--------------+-----------+-----------+-----------+-------------
 15421217 | testpub |    16394 | f            | t         | t         | t         | t
(1 row)

pg102=> SELECT * FROM pg_publication_tables;
 pubname | schemaname | tablename
---------+------------+-----------
 testpub | public     | reptab1
 testpub | public     | reptab2
(2 rows)
```

6. Create a subscription on the target database.
```
postgres=# CREATE SUBSCRIPTION testsub CONNECTION 'host=pg800.cyt4dgtj55oy.us-east-2.rds.amazonaws.com port=5432 dbname=pg102 user=postgres password=Pass' PUBLICATION testpub;
NOTICE:  created replication slot "testsub" on publisher
CREATE SUBSCRIPTION
postgres=# SELECT oid,subname,subenabled,subslotname,subpublications FROM pg_subscription;
  oid  | subname | subenabled | subslotname | subpublications
-------+---------+------------+-------------+-----------------
 16411 | testsub | t          | testsub     | {testpub}
(1 row)
```

7. Confirm data has/is being replicated.
```
postgres=# SELECT count(*) FROM reptab1;
 count
-------
  1000
(1 row)

postgres=# SELECT count(*) FROM reptab2;
 count
-------
    50
(1 row)
```






