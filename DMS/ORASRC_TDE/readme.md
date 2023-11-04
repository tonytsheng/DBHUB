##

aws rds create-db-instance --db-name ttsora99 --db-instance-identifier ttsora99 --engine oracle-ee --master-username admin --master-user-password Pass1234 --db-instance-class db.m5.large --allocated-storage 20 --profile dba --db-subnet-group-name "default-vpc-0dc155aace16a70a7" --availability-zone us-east-2a

##
Create new option group
Add TDE option to it. [Should add S3_INTEGRATION too ]
Modify instance to use that option group.
Note - could not figure out how to do this in the cli.
Error message that the option group was not assigned to a specific VPC.
Reboot instance if needed to make sure it gets applied.
aws rds add-option-to-option-group --option-group-name tts19-ssl  --apply-immediately --options OptionName=TDE  --profile dba

##
Check the status of the wallet.
```
ADMIN/ttsora99> SELECT * FROM v$encryption_wallet;

WRL_TYPE
--------------------
WRL_PARAMETER
--------------------------------------------------------------------------------
STATUS                         WALLET_TYPE          WALLET_OR KEYSTORE FULLY_BAC
------------------------------ -------------------- --------- -------- ---------
    CON_ID
----------
FILE
/rdsdbbin/oracle/dbs/wallet/
OPEN                           PASSWORD             SINGLE    NONE     NO
         0


ADMIN/ttsora99> create tablespace customer_orders_enc encryption default storage (encrypt);

Tablespace created.

ADMIN/ttsora99>
```
Create database tables on the encrypted tablespace.
Encrypt the column.
Populate some data in there with blob data in the encrypted column.

CUSTOMER_ORDERS/ttsora99> desc customer_orders.orders
 Name                                      Null?    Type
 ----------------------------------------- -------- ----------------------------
 ORDER_ID                                  NOT NULL NUMBER(38)
 ORDER_DATETIME                            NOT NULL TIMESTAMP(6)
 CUSTOMER_ID                               NOT NULL NUMBER(38)
 ORDER_STATUS                              NOT NULL VARCHAR2(10 CHAR)
 STORE_ID                                  NOT NULL NUMBER(38)
 ORDER_IMG                                          BLOB ENCRYPT

CUSTOMER_ORDERS/ttsora99>

CUSTOMER_ORDERS/ttsora99> select count(*), (dbms_lob.getlength(order_img))/1024/1024 as SizeMB
    from customer_orders.orders
    group by (dbms_lob.getlength(order_img))/1024/1024;
  2    3
  COUNT(*)     SIZEMB
---------- ----------
        33 1.80327892
      1102
         1 .157166481

CUSTOMER_ORDERS/ttsora99> select order_id ,  (dbms_lob.getlength(order_img))/1024/1024 as SizeMB
from customer_orders.orders
where (dbms_lob.getlength(order_img))/1024/1024 > 1;
  2    3
  ORDER_ID     SIZEMB
---------- ----------
       695 1.80327892
      2012 1.80327892
      2013 1.80327892
      2014 1.80327892
      2015 1.80327892
      2016 1.80327892
      2017 1.80327892
      2018 1.80327892
      2019 1.80327892
      2020 1.80327892
```

