## Federated Query from RDS and S3
Federated queries, queries across multiple data stores, is an interesting problem to solve. Here are some details using an RDS for PostgreSQL instance and a csv file stored in S3 using Athena as our query tool. The bulk of this was taken from https://aws.amazon.com/blogs/database/joining-historical-data-between-amazon-athena-and-amazon-rds-for-postgresql/ but using our own data.
### RDS for PostgreSQL
We loaded a subset of publically available airport data, but just a subset of it, into an airport table. Here is what the table looks like. Data was loaded from the corresponding sql file.
```
pg102=> \d fly.airport
                          Table "fly.airport"
    Column    |         Type          | Collation | Nullable | Default
--------------+-----------------------+-----------+----------+---------
 airport_code | character varying(4)  |           | not null |
 airport_name | character varying(60) |           | not null |
 airport_c    | numeric               |           |          |
 iata_code    | character varying(3)  |           |          |
Indexes:
    "airport_pk" PRIMARY KEY, btree (airport_code, airport_name)
    "airport_pkidx" UNIQUE, btree (airport_code, airport_name)
```

### CSV file in S3
We took the full airport data in csv format and loaded that into an S3 bucket. We then create the corresponding database in the AWS Glue Data Catalog.
```
CREATE EXTERNAL TABLE `s3airport`.`airport` (
ident char(9)
,type char(9)
,name char(9)
,elevation_ft char(9)
,continent  char(9)
,iso_country char(9)
,iso_region char(9)
,municipality char(9)
,gps_code char(9)
,iata_code char(9)
,local_code char(9)
,coordinates char(9)
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe'
WITH SERDEPROPERTIES ('field.delim' = ',')
STORED AS INPUTFORMAT 'org.apache.hadoop.mapred.TextInputFormat' OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION 's3://ttsheng-athena/'
TBLPROPERTIES ('classification' = 'csv');
```
### Create a Data source and AWS Lambda Function
See the blog post for creating the data source.
In some regions, the Serverless Application Repository has been deprecated in lieu of the CloudFormation Registry which has yet to be integrated with Athena. Instead you can follow these instructions for PostgreSQL for RDS. https://github.com/awslabs/aws-athena-query-federation/wiki/Deploy-the-Athena-PostgreSQL-Connector-without-using-SAM

Here are the specifics for the Lambda function.
- Application name, keep the default AthenaPostgreSQLConnector.
- CompositeHandler, enter PostGreSqlMuxCompositeHandler.
- SecretNamePrefix, enter AthenaPostgreSQLFederation.
- SpillBucket, enter your S3 bucket name (for this post, historicalbucket).
- ConnectionString, follow the below format postgres://jdbc:postgresql://<RDSEndpoint>:port/<dbname>?user=<username>&password=<password>
- LambdaFunctionName, enter postgresqlathena.
- LambdaMemory and LambdaTimeout, keep the default values.
- SecurityGroupIds, enter the security group ID that is associated to the VPC ID corresponding to your subnet.
- SpillPrefix, create a folder under the S3 bucket you created and specify the name (for this post, athena-spill).
- Subnetids, enter the corresponding subnet that the Lambda function can use to access your data source. For example: subnet1, subnet2.

### Query Testing
Run the following to get a sense of looking at the data.
```
select count(*) from s3airport.airport;
select count(*) from pg102.fly.airport;

select * 
from awsdatacatalog.s3airport.airport s3airport
, pg102.fly.airport pg102airport 
where s3airport.iata_code='CDG' 
and s3airport.iata_code=pg102airport.iata_code;
```
