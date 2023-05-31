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

in console, use role name rds-s3-export 
