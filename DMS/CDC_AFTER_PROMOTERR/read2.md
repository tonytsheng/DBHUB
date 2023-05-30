## Intro
One of the benefits of RDS databases is the Multi Availability Zone (MultiAZ) solution. Since RDS is a managed service, the ability to provision a primary database, with a standby database in a different availability zone, all without managing hardware or installing software is a feature that our customers love. MultiAZ databases help solve many of the typical high availability challenges our customers face. In some cases, MultiAZ databases do not provide enough high availability since both the primary and standby get database engine patches at the same time. 

In this post, we discuss using the combination of RDS Read Replicas and the Change Data Capture (CDC) functionality of the Database Migraton Service (DMS) to provide database minimal downtime.

## Solution Overview


