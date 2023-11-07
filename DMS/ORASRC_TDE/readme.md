## Base config
- Oracle running on an EC2 machine [Yoda Labs AMI]
- TDE configured for this database
- Put database into archivelog mode
- Set db_recovery_file_dest_size
- grant appropriate perms to customer_orders user
- customer_orders schema
- orders is a single table in the schema with an encrypted column sitting on an encrypted tablespace
- Use customer_orders for the DMS endpoint

https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Source.Oracle.html#CHAP_Source.Oracle.Encryption
- Get the location of the wallet
```
SQL> SELECT WRL_PARAMETER FROM V$ENCRYPTION_WALLET;

WRL_PARAMETER
--------------------------------------------------------------------------------
/u01/app/oracle/admin/oradev/wallet/
```
- Find the object that is encrypted.
```
SQL> SELECT OBJECT_ID FROM ALL_OBJECTS WHERE OWNER='CUSTOMER_ORDERS' AND OBJECT_NAME='ORDERS' AND OBJECT_TYPE='TABLE';

 OBJECT_ID
----------
    112359

SQL> SELECT MKEYID FROM SYS.ENC$ WHERE OBJ#=112359;

MKEYID
----------------------------------------------------------------
AdAI4ksPz0//v5j6Cjf8ZQ0AAAAAAAAAAAAAAAAAAAAAAAAAAAAA
```
The trailing AAA characters is not part of the value.

Confirm tablespace encryption.
```
SQL> SELECT TABLESPACE_NAME, ENCRYPTED FROM dba_tablespaces;

TABLESPACE_NAME                ENC
------------------------------ ---
SYSTEM                         NO
SYSAUX                         NO
UNDOTBS1                       NO
TEMP                           NO
USERS                          NO
CUSTOMER_ORDERS_ENC            YES

6 rows selected.

SQL> SELECT name,utl_raw.cast_to_varchar2( utl_encode.base64_encode('01'||substr(mkeyid,1,4))) || utl_raw.cast_to_varchar2( utl_encode.base64_encode(substr(mkeyid,5,length(mkeyid)))) masterkeyid_base64
FROM (SELECT t.name, RAWTOHEX(x.mkid) mkeyid FROM v$tablespace t, x$kcbtek x WHERE t.ts#=x.ts#)
WHERE name = 'CUSTOMER_ORDERS_ENC';
  2    3
NAME
------------------------------
MASTERKEYID_BASE64
--------------------------------------------------------------------------------
CUSTOMER_ORDERS_ENC
AdAI4ksPz0//v5j6Cjf8ZQ0=
```
The trailing '=' character is not part of the value.

Get the password for the encryption keys.
```
[oracle@ip-10-0-2-188 wallet]$ mkstore -wrl /u01/app/oracle/admin/oradev/wallet/  -list
Oracle Secret Store Tool : Version 12.2.0.1.0
Copyright (c) 2004, 2016, Oracle and/or its affiliates. All rights reserved.

Enter wallet password:
Oracle Secret Store entries:
ORACLE.SECURITY.DB.ENCRYPTION.AdAI4ksPz0//v5j6Cjf8ZQ0AAAAAAAAAAAAAAAAAAAAAAAAAAAAA
ORACLE.SECURITY.DB.ENCRYPTION.MASTERKEY
ORACLE.SECURITY.ID.ENCRYPTION.
ORACLE.SECURITY.KB.ENCRYPTION.
ORACLE.SECURITY.KM.ENCRYPTION.AdAI4ksPz0//v5j6Cjf8ZQ0AAAAAAAAAAAAAAAAAAAAAAAAAAAAA

[oracle@ip-10-0-2-188 wallet]$ mkstore -wrl /u01/app/oracle/admin/oradev/wallet/  -viewEntry ORACLE.SECURITY.DB.ENCRYPTION.AdAI4ksPz0//v5j6Cjf8ZQ0AAAAAAAAAAAAAAAAAAAAAAAAAAAAA
Oracle Secret Store Tool : Version 12.2.0.1.0
Copyright (c) 2004, 2016, Oracle and/or its affiliates. All rights reserved.

Enter wallet password:
ORACLE.SECURITY.DB.ENCRYPTION.AdAI4ksPz0//v5j6Cjf8ZQ0AAAAAAAAAAAAAAAAAAAAAAAAAAAAA = AEMAASAAzz8dfB/n5MWRlEBxs6Ya3YAUQGHA4EVpvVIho0wBGMYDEAA9MiwNkiHGAkd9O6b3yCnhBQcAeHsLBg8DFQ==

```
Specify the TDE encryption key name for the Oracle source endpoint by setting the securityDbEncryptionName extra connection attribute.
```
securityDbEncryptionName=ORACLE.SECURITY.DB.ENCRYPTION.AdAI4ksPz0//v5j6Cjf8ZQ0AAAAAAAAAAAAAAAAAAAAAAAAAAAAA
```

Provide the associated TDE password for this key on the console as part of the Oracle source's Password value. Use the following order to format the comma-separated password values, ended by the TDE password value [no ASM]
This is in the endpoint attributes for the Password field
```
Oracle_db_password,,AEMAASAAzz8dfB/n5MWRlEBxs6Ya3YAUQGHA4EVpvVIho0wBGMYDEAA9MiwNkiHGAkd9O6b3yCnhBQcAeHsLBg8DFQ==
Pass,,AEMAASAAzz8dfB/n5MWRlEBxs6Ya3YAUQGHA4EVpvVIho0wBGMYDEAA9MiwNkiHGAkd9O6b3yCnhBQcAeHsLBg8DFQ==
```

- Adding a second non encrypted table to the source database works fine - the migration task picks it right up.
