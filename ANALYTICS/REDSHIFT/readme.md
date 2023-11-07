- also see https://github.com/awslabs/amazon-redshift-utils/

https://catalog.us-east-1.prod.workshops.aws/workshops/9f29cdba-66c0-445e-8cbb-28a092cb5ba7/en-US


## From the Redshift Workshop
make sure that the iam role assigned to the cluster has been set as default
then when you do the copy command:

copy customer from 's3://redshift-immersionday-labs/data/customer/customer.tbl.'
iam_role default
region 'us-west-2' lzop delimiter '|' COMPUPDATE PRESET;

redshift-cluster-1:5439 awsuser@dev=# explain
dev-# select n_name, s_name, l_shipmode, SUM(L_QUANTITY) Total_Qty
dev-# from lineitem
dev-# join supplier on l_suppkey = s_suppkey
dev-# join nation on s_nationkey = n_nationkey
dev-# where datepart(year, L_SHIPDATE) > 1997
dev-# group by 1,2,3
dev-# order by 3 desc
dev-# limit 1000;
                                                                       QUERY PLAN

-----------------------------------------------------------------------------------------------------------------------------
---------------------------
 XN Limit  (cost=1000001760030.21..1000001760032.71 rows=1000 width=57)
   ->  XN Merge  (cost=1000001760030.21..1000001779460.71 rows=7772202 width=57)
         Merge Key: derived_table1.grvar_2
         ->  XN Network  (cost=1000001760030.21..1000001779460.71 rows=7772202 width=57)
               Send to leader
               ->  XN Sort  (cost=1000001760030.21..1000001779460.71 rows=7772202 width=57)
                     Sort Key: derived_table1.grvar_2
                     ->  XN HashAggregate  (cost=851075.38..870505.89 rows=7772202 width=57)
                           ->  XN Hash Join DS_DIST_ALL_NONE  (cost=47804.38..773353.36 rows=7772202 width=57)
                                 Hash Cond: ("outer".s_nationkey = "inner".n_nationkey)
                                 ->  XN Hash Join DS_DIST_ALL_NONE  (cost=47803.60..715061.04 rows=7772202 width=54)
                                       Hash Cond: ("outer".grvar_1 = "inner".s_suppkey)
                                       ->  XN Seq Scan on mv_tbl__supplier_shipmode_agg__0 derived_table1  (cost=0.00..611041.70 rows=6941890 width=32)
--                                                        ^^^ - using the MV
                                             Filter: (grvar_3 > 1997)
                                       ->  XN Hash  (cost=11000.00..11000.00 rows=1100000 width=38)
                                             ->  XN Seq Scan on supplier  (cost=0.00..11000.00 rows=1100000 width=38)
                                 ->  XN Hash  (cost=0.25..0.25 rows=25 width=19)
                                       ->  XN Seq Scan on nation  (cost=0.00..0.25 rows=25 width=19)
(18 rows)

materialized view refresh is asynchronous - allow ~5 minutes


