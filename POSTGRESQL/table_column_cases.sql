create table "TONYSHENG" (col1 int);
create table tonysheng (col1 int);
create table "TonyShengNo1" ("COLUMN1" int, "Column2" int);
create table "tONYsHENGNo2" ("ColumnnoTwo" int);

pg102=> \dt
                        List of relations
  Schema  |             Name              | Type  |     Owner
----------+-------------------------------+-------+---------------
 postgres | TONYSHENG                     | table | postgres
 postgres | TonyShengNo1                  | table | postgres
 postgres | base_esri                     | table | postgres
 postgres | databasechangelog             | table | postgres
 postgres | databasechangeloglock         | table | postgres
 postgres | esritestthree                 | table | postgres
 postgres | langchain_pg_collection       | table | postgres
 postgres | langchain_pg_embedding        | table | postgres
 postgres | lb_test_one                   | table | postgres
 postgres | lb_test_two                   | table | postgres
 postgres | log                           | table | postgres
 postgres | mdrt_22eb0$                   | table | postgres
 postgres | tONYsHENGNo2                  | table | postgres
 postgres | tonysheng                     | table | postgres
 postgres | ttsheng_test_oid              | table | postgres
 public   | awsdms_apply_exceptions       | table | dms_user
 public   | awsdms_ddl_audit              | table | postgres
 public   | awsdms_validation_failures_v1 | table | dms_user
 public   | important                     | table | postgres
 public   | pgbench_accounts              | table | postgres
 public   | pgbench_branches              | table | postgres
 public   | pgbench_history               | table | postgres
 public   | pgbench_tellers               | table | postgres
 public   | spatial_ref_sys               | table | rdsadmin
 public   | t1                            | table | postgres
 public   | ttsheng_t1                    | table | postgres
 topology | layer                         | table | rds_superuser
 topology | topology                      | table | rds_superuser
(28 rows)



pg102=> \d tonysheng;
            Table "postgres.tonysheng"
 Column |  Type   | Collation | Nullable | Default
--------+---------+-----------+----------+---------
 col1   | integer |           |          |

pg102=> \d "TonyShengNo1" ;
           Table "postgres.TonyShengNo1"
 Column  |  Type   | Collation | Nullable | Default
---------+---------+-----------+----------+---------
 COLUMN1 | integer |           |          |
 Column2 | integer |           |          |




create table "ReportCaseTest" ("COLOR" varchar(20), "Product" varchar(20));
insert into  "ReportCaseTest" ("COLOR", "Product") values ("Green", "Bike");
insert into  "ReportCaseTest" values ("Yellow", "Bike");
insert into  "ReportCaseTest" values ("Red", "Bike");
insert into  "ReportCaseTest" values ("Red", "Car");

