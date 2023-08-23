1. Documentation
  - https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Appendix.Oracle.Options.SSL.html#Appendix.Oracle.Options.SSL.JDBC
  - https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/UsingWithRDS.SSL.html#UsingWithRDS.SSL.CertificatesAllRegions
  - See the section on "Sample script for importing certificates into your trust store"
  - We used the rds-ca-2019-root.pem file.

2. Start an EC2 instance that has the Oracle software preloaded [internal AWS ami]
  - this instance has the full oracle software loaded on it as well as an oradev instance running
  - this instance will act as a database 'client' and sits in the same VPC as the RDS instance.

3. Start an RDS instance in the same VPC. Create a new option group to include SSL. Assign the instance to use this option group.

4. On the EC2 instance, create a tnsanames file with two entries, one for the standard TCP connection and one for the TCPS connection.  See documentation for specifics.

4. Edit the sqlnet.ora file according to the documentation.

5. Test the connections using SQLPlus. 
  - SQLPlus over TCP should work.
  - SQLPlus over TCPS should not work.

7. Test the connections using tnsping.
```
[oracle@ip-10-1-0-15 admin]$ tnsping ttsora20

TNS Ping Utility for Linux: Version 12.2.0.1.0 - Production on 23-AUG-2023 16:39:30

Copyright (c) 1997, 2016, Oracle.  All rights reserved.

Used parameter files:
/u01/app/oracle/product/12.2.0.1/db_1/network/admin/sqlnet.ora


Used TNSNAMES adapter to resolve the alias
Attempting to contact (DESCRIPTION = (ADDRESS_LIST = (ADDRESS = (PROTOCOL = TCP) (HOST = ttsora20.ciushqttrpqx.us-east-2.rds.amazonaws.com) (PORT = 1521))) (CONNECT_DATA = (SID = ttsora20)))
OK (20 msec)
[oracle@ip-10-1-0-15 admin]$ tnsping ttsora20_ssl

TNS Ping Utility for Linux: Version 12.2.0.1.0 - Production on 23-AUG-2023 16:39:32

Copyright (c) 1997, 2016, Oracle.  All rights reserved.

Used parameter files:
/u01/app/oracle/product/12.2.0.1/db_1/network/admin/sqlnet.ora


Used TNSNAMES adapter to resolve the alias
Attempting to contact (DESCRIPTION = (ADDRESS_LIST = (ADDRESS = (PROTOCOL = TCPS) (HOST = ttsora20.ciushqttrpqx.us-east-2.rds.amazonaws.com) (PORT = 2484))) (CONNECT_DATA = (SID = ttsora20)) (SECURITY = (SSL_SERVER_CERT_DN = C=US,ST=Washington,L=Seattle,O=Amazon.com,OU=RDS,CN=endpoint)))
TNS-12560: TNS:protocol adapter error
```

8. Copy over rds root pem file into the ssl_wallet directory.

9. Run orapki commands.
```
[oracle@ip-10-1-0-15 db_1]$ orapki wallet create -wallet $ORACLE_HOME/ssl_wallet -auto_login_only
Oracle PKI Tool : Version 12.2.0.1.0
Copyright (c) 2004, 2016, Oracle and/or its affiliates. All rights reserved.

Operation is successfully completed.
[oracle@ip-10-1-0-15 db_1]$ cd ssl_wallet/
[oracle@ip-10-1-0-15 ssl_wallet]$ ls -l
total 8
-rw------- 1 oracle oinstall  194 Aug 23 16:41 cwallet.sso
-rw------- 1 oracle oinstall    0 Aug 23 16:41 cwallet.sso.lck
-rw-r--r-- 1 oracle oinstall 1456 Aug 23 16:40 rds-ca-2019-root.pem
[oracle@ip-10-1-0-15 ssl_wallet]$ orapki wallet add -wallet $ORACLE_HOME/ssl_wallet -trusted_cert -cert $ORACLE_HOME/ssl_wallet/rds-ca-2019-root.pem -auto_login_only
Oracle PKI Tool : Version 12.2.0.1.0
Copyright (c) 2004, 2016, Oracle and/or its affiliates. All rights reserved.

Operation is successfully completed.
[oracle@ip-10-1-0-15 ssl_wallet]$
```
10. Test with tnsping.
```
[oracle@ip-10-1-0-15 ssl_wallet]$ tnsping ttsora20_ssl

TNS Ping Utility for Linux: Version 12.2.0.1.0 - Production on 23-AUG-2023 16:42:30

Copyright (c) 1997, 2016, Oracle.  All rights reserved.

Used parameter files:
/u01/app/oracle/product/12.2.0.1/db_1/network/admin/sqlnet.ora


Used TNSNAMES adapter to resolve the alias
Attempting to contact (DESCRIPTION = (ADDRESS_LIST = (ADDRESS = (PROTOCOL = TCPS) (HOST = ttsora20.ciushqttrpqx.us-east-2.rds.amazonaws.com) (PORT = 2484))) (CONNECT_DATA = (SID = ttsora20)) (SECURITY = (SSL_SERVER_CERT_DN = C=US,ST=Washington,L=Seattle,O=Amazon.com,OU=RDS,CN=endpoint)))
OK (20 msec)
```
11. Test the connection using SQLPlus.
```
[oracle@ip-10-1-0-15 admin]$ sqlplus admin/Pass1234@ttsora20_ssl

SQL*Plus: Release 12.2.0.1.0 Production on Wed Aug 23 16:45:35 2023

Copyright (c) 1982, 2016, Oracle.  All rights reserved.

Last Successful login time: Wed Aug 23 2023 16:43:40 +00:00

Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production

SQL> quit
Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
```

