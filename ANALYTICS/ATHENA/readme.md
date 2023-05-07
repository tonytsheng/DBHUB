## Query from S3
- See instructions for Glue Crawler to crawl and S3 bucket and make an Athena table from files in a bucket
- From Glue, Tables -> Actions -> View Data
  - Will take you to Athena and auto generate the query with all the right attributes and syntax. You can then edit the query as well:
``` SELECT desc, count(*) FROM "AwsDataCatalog"."ttsheng-gluedb"."12" where country='France' group by desc order by count(*)```

aws athena list-data-catalogs
aws athena list-databases --catalog-name pg102

```

