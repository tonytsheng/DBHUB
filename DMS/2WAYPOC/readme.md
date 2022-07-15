DMS 2WAY Replication Proof of Concept

At AWS, we talk a lot about 2 way doors - in business, speed matters and most decisions are not 1 way doors but 2 way doors - you can make the decision to walk through the door and walk right back if it doesn't work out. Database migrations can architected to be similar. 

These are components for a simple proof of concept for a DMS bi directional replication architecture. This includes:
- A DynamoDB table that contains database endpoint information. Depending on the supplied parameter, it will execute an insert on the old or the new database.
- A python script that retrieves information from DDB and then applies the insert.
- Database objects for Oracle and PostgreSQL
- DMS cli commands to create a replication instance, database endpoints and migration tasks.

![Optional Text](2way.jpg)
====
Set up DynamoDB 

- 1.cr8.ddb.appmap.py - create a DynamoDB table to store appmap information
- 2.ins.dyn.appmap.py - load a DynamoDB table called appmap with application id and database endpoint information

====
Set up RDBMS source and target 
Create your user/schemas/etc

- 3.cr8.ora.heart.sql - create an example heartbeat table in oracle
- 3.cr8.pg.heart.sql - create an example heartbeat table in postgresql

====
Set up DMS - you will need to edit for the appropriate arns

- 4.cr8.dms.repinstance.cli - set up a replication instance
- 5.cr8.dms.endpts.cli - set up source and target database endpoints
- 6.cr8.dms.migtaskfwd.cli - create forward migration task
- 7.cr8.dms.migtaskbck.cli - create backward migration task


====
To run the simulated app:
- python3 appinsert.v3.py SITEA|SITEB

====


2022-07-14
- Added Architecture diagram

2022-06-30
- Cleanup
- Added DMS CLI setup scripts - rep instance, endpoints, migration task

2022-06-17
- Read from DynamoDB table based on input parameter
- Get engine
- Insert and Query latest based on which engine, inserting respective SITE
- Note that DMS migration tasks are not in this repo
- ins.dyn.appmap.py - loads appmap DDB table
- scan.dyn.appmap.cli - query appmap DDB table


- Heartbeat table, Unique index, Sequence
- Driver script to load data based on either SITEA or SITEB as an input parameter
- appmap - mapping file for database connection info based on site
- v2 - loaded appmap data into a dynamodb table - see ins.ddb.appmap.py


