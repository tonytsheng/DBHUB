1 create an external schema that points to aurora
https://docs.aws.amazon.com/redshift/latest/dg/federated_query_example.html
turn on Enhanced VPC networking for your cluster when you create it - you cannot modify this after you create it
```
CREATE EXTERNAL SCHEMA apg
FROM POSTGRES
DATABASE 'database-1' SCHEMA 'myschema'
URI 'endpoint to aurora hostname'
IAM_ROLE 'arn:aws:iam::123456789012:role/Redshift-SecretsManager-RO'
SECRET_ARN 'arn:aws:secretsmanager:us-west-2:123456789012:secret:federation/test/dataplane-apg-creds-YbVKQw';

2 create an external schema that points to s3, grant permission
CREATE EXTERNAL SCHEMA s3 
FROM DATA CATALOG 
DATABASE 'default' REGION 'us-west-2' 
IAM_ROLE 'arn:aws:iam::123456789012:role/Redshift-S3'; 

GRANT USAGE ON SCHEMA s3 TO public;

3 query the external schemas
SELECT count(*) FROM public.lineitem; 		-- the redshift table
SELECT count(*) FROM apg.lineitem;		-- the aurora table
SELECT count(*) FROM s3.lineitem_1t_part;	-- the s3 table

4 the view across all data sources
CREATE VIEW lineitem_all AS
  SELECT l_orderkey,l_partkey,l_suppkey,l_linenumber,l_quantity,l_extendedprice,l_discount,l_tax,l_returnflag,l_linestatus,
         l_shipdate::date,l_commitdate::date,l_receiptdate::date, l_shipinstruct ,l_shipmode,l_comment 
  FROM s3.lineitem_1t_part 
  UNION ALL SELECT * FROM public.lineitem 
  UNION ALL SELECT * FROM apg.lineitem 
     with no schema binding;
```

## Create external schema to RDS PG [not Aurora like above]
- create iam policy
- create role and attach policy
- assign iam role to redshift cluster
  - https://docs.aws.amazon.com/redshift/latest/dg/federated-create-secret-iam-role.html
```
CREATE EXTERNAL SCHEMA rdspg102
FROM POSTGRES
DATABASE 'pg102' SCHEMA 'human_resources'
URI 'pg102.cyt4dgtj55oy.us-east-2.rds.amazonaws.com' PORT 5432
IAM_ROLE 'arn:aws:iam::070201068661:role/ttsheng_rol_redshift_secrets'
SECRET_ARN 'arn:aws:secretsmanager:us-east-2:070201068661:secret:pg102-secret-IZWCR2';

CREATE EXTERNAL SCHEMA rdspg102_1
FROM POSTGRES
DATABASE 'pg102' SCHEMA 'human_resources'
URI 'pg102.cyt4dgtj55oy.us-east-2.rds.amazonaws.com' PORT 5432
IAM_ROLE 'arn:aws:iam::070201068661:role/ttsheng_rol_redshift_secrets'
SECRET_ARN 'arn:aws:secretsmanager:us-east-2:070201068661:secret:pg102-secret-IZWCR2';
```

## Connect to a self managed Postgresql database on ec2 
create your database
the connect string looks like this: jdbc:postgresql://ip-10-0-0-25.us-east-2.compute.internal:5432/ttsheng_db

Check that your Redshift cluster can access the aws glue data catalog
https://docs.aws.amazon.com/redshift/latest/mgmt/query-editor-v2-glue.html
SHOW SCHEMAS FROM DATABASE awsdatacatalog;

The associated IAM role(s) with the Redshift Cluster should include one of the AmazonRedshiftQueryEditorV2* policies.

```
CREATE EXTERNAL SCHEMA ttsheng_db
FROM POSTGRES
DATABASE 'ttsheng_db'
URI 'ip-10-0-2-111.us-east-2.compute.internal' PORT 5432
IAM_ROLE 'arn:aws:iam::070201068661:role/ttsheng_rol_redshift_secrets'
SECRET_ARN 'arn:aws:secretsmanager:us-east-2:070201068661:secret:pg102-secret-IZWCR2';

```

## Troubleshooting
- Ehanced VPC only necessary if queriees to RDS instances located in a peered VPC.

- IAM role not associated with RS cluster
```
ERROR:  Failed to incorporate external table "rdspg102_1"."countries" into local catalog. Error=exception name : UnauthorizedException, error type : 136, message: The requested role arn:aws:iam::070201068661:role/ttsheng-redshift-etc is not associated to cluster, should retry : 0
```

- Can't access SecretsMgr
Open TCP 443 outbound rule in SecurityGroup that Redshift Cluster is running in.
```
ERROR:  Failed to incorporate external table "rdspg102"."countries" into local catalog. Error=: curlCode: 28, Timeout was reached
ERROR:  Failed to incorporate external table "rdspg102_1"."countries" into local catalog. Error=: curlCode: 7, Couldn't connect to server
```

https://spaeder.io/2020/04/20/aws-redshift-federated-querying-from-postgres/
https://docs.aws.amazon.com/redshift/latest/mgmt/connecting-refusal-failure-issues.html


