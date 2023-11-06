##
- Create or procure a host with a self managed Oracle database on it.
- Configure it for Oracle TDE.
  - add wallet location to sqlnet.ora


mkdir /u01/app/oracle/admin/oradev/wallet/tde_seps

ADMINISTER KEY MANAGEMENT ADD SECRET 'Pass1234'
FOR CLIENT 'TDE_WALLET'
TO [LOCAL] AUTO_LOGIN KEYSTORE '/u01/app/oracle/admin/oradev/wallet/tde_seps';

  1  ADMINISTER KEY MANAGEMENT ADD SECRET 'Pass1234'
  2  FOR CLIENT 'TDE_WALLET'
  3* TO LOCAL AUTO_LOGIN KEYSTORE '/u01/app/oracle/admin/oradev/wallet/tde_seps'
SYS/oradev> /

SYS/oradev> ALTER SYSTEM SET EXTERNAL_KEYSTORE_CREDENTIAL_LOCATION = "/u01/app/oracle/admin/oradev/wallet/tde_seps" SCOPE = SPFILE;

System altered.

restart

SYS/oradev> ADMINISTER KEY MANAGEMENT CREATE KEYSTORE '/u01/app/oracle/admin/oradev/wallet' IDENTIFIED BY Pass1234;

keystore altered.

Note the files on the file system
[oracle@ip-10-0-2-180 wallet]$ pwd
/u01/app/oracle/admin/oradev/wallet
[oracle@ip-10-0-2-180 wallet]$ ls -l
total 8
-rw------- 1 oracle oinstall 2408 Nov  4 20:32 ewallet.p12
drwxr-xr-x 2 oracle oinstall 4096 Nov  4 20:28 tde_seps
[oracle@ip-10-0-2-180 wallet]$ cd tde_seps/
[oracle@ip-10-0-2-180 tde_seps]$ ls -l
total 8
-rw-r--r-- 1 oracle oinstall  150 Nov  4 20:28 afiedt.buf
-rw------- 1 oracle oinstall 3915 Nov  4 20:28 cwallet.sso

create auto login for keystore

SYS/oradev> ADMINISTER KEY MANAGEMENT CREATE AUTO_LOGIN KEYSTORE FROM KEYSTORE
'/u01/app/oracle/admin/oradev/wallet/' IDENTIFIED BY Pass1234;
  2
keystore altered.

ADMINISTER KEY MANAGEMENT SET KEYSTORE OPEN CONTAINER=ALL;

create tablespace customer_orders_enc 
datafile '/u01/app/oracle/oradata/oradev/customer_orders_enc.dbf' 
size 100M autoextend on maxsize 1G extent management
local segment
space management
auto encryption default storage (encrypt);




Create an encrypted tablespace.
Create tables on the encrypted tablespace.
Create the orders table with an encrypted column that is a BLOB datatype.
Insert some rows into it.




