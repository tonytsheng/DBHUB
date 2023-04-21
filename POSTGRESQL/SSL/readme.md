## Connection Strings
```
psql "host=pg201.cyt4dgtj55oy.us-east-2.rds.amazonaws.com port=5432 user=postgres dbname=pg201 sslmode=verify-full sslrootcert=/home/ec2-user/ssl/rds-combined-ca-bundle.pem"
psql "host=pg201.cyt4dgtj55oy.us-east-2.rds.amazonaws.com port=5432 user=postgres dbname=pg201 "
```
[ec2-user@ip-10-0-2-111 ~]$ /usr/pgsql-14/bin/psql "host=pg201.cyt4dgtj55oy.us-east-2.rds.amazonaws.com port=5432 user=postgres dbname=pg201  sslmode=verify-full"
psql: error: connection to server at "pg201.cyt4dgtj55oy.us-east-2.rds.amazonaws.com" (10.0.0.246), port 5432 failed: root certificate file "/home/ec2-user/.postgresql/root.crt" does not exist
Either provide the file or change sslmode to disable server certificate verification.

