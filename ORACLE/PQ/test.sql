set echo on;
set serveroutput on;
set timing on;
set linesize 200
set pagesize 50
set trim
show parameter parallel;
drop table big;
host(sleep 2);

create table big as select * from all_objects;
commit;
host(sleep 2);
insert /*+ append */ into big select * from big;
commit;
host(sleep 2);
insert /*+ append */ into big select * from big;
commit;
host(sleep 2);
insert /*+ append */ into big select * from big;
commit;
host(sleep 2);
insert /*+ append */ into big select * from big;
commit;
host(sleep 2);
insert /*+ append */ into big select * from big;
commit;
host(sleep 2);
insert /*+ append */ into big select * from big;
commit;
host(sleep 2);

set autotrace on;
select count(*) from big;
select /*+ FULL(big) PARALLEL(big,2) */ count(*) from big;
select /*+ FULL(big) PARALLEL(big,4) */ count(*) from big;
select /*+ FULL(big) PARALLEL(big,16) */ count(*) from big;
exit


