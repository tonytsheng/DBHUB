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
URI 'pg102.cyt4dgtj55oy.us-east-2.rds.amazonaws.com'
IAM_ROLE 'arn:aws:iam::070201068661:role/ttsheng_rol_redshift_secrets'
SECRET_ARN 'arn:aws:secretsmanager:us-east-2:070201068661:secret:pg102-secret-IZWCR2';

rs101:5439 awsuser@dev=# select count(*) from rdspg102.countries;
ERROR:  timeout expired
```





