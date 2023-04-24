## 
Add S3 VPC Gateway Endpoint:
https://stackoverflow.com/questions/55972886/could-not-find-s3-endpoint-or-nat-gateway-for-subnetid

Add Glue VPC endpoint

Add Glue Service Role
glue service role must have:
cloudwatchfull
ec2full
s3full
glueservicenotebookrole
glueconsolefullaccess
rdsfullaccess

Create Data Connection
RDS instance

create glue catalog
ttsgluecatlog

create crawler
using the data source and glue catalog
TTSORA10/%

run crawler on demand
should see hundreds of tables

aws glue get-tables --database-name ttsgluecatalog --profile dba

