## Create IAM policy and role
```
aws iam create-policy  --policy-name ttsheng-s3-exportPolicy --policy-document '{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "ExportPolicy",
            "Effect": "Allow",
            "Action": [
                "s3:PutObject*",
                "s3:ListBucket",
                "s3:GetObject*",
                "s3:DeleteObject*",
                "s3:GetBucketLocation"
            ],
            "Resource": [
                "arn:aws:s3:::ttsheng-athena",
                "arn:aws:s3:::ttsheng-athena/*"
            ]
        }
    ]
}'

aws iam create-role  --role-name rds-s3-export-role  --assume-role-policy-document '{
     "Version": "2012-10-17",
     "Statement": [
       {
         "Effect": "Allow",
         "Principal": {
            "Service": "export.rds.amazonaws.com"
          },
         "Action": "sts:AssumeRole"
       }
     ] 
   }'

aws iam attach-role-policy  --policy-arn arn:aws:iam::070201068661:policy/ttsheng-s3-exportPolicy   --role-name rds-s3-export-role
```

## Choose which snapshot to export to specific S3 bucket
in the RDS console, choose which snapshot to export, which destination bucket, and which role to use to export the data (rds-s3-export)

## S3 export will show a status
Once this is complete, each database table will have one or more parquet files in your S3 bucket.

## Use Athena to query
create data source in athena - will need to fill out all the columns of the table
query looks something like this
select count(*) from "pg102s3exp-co-products" 

