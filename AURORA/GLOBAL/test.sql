# run at the replica
set aurora_replica_read_consistency = 'eventual';
select * from t1;
insert into t1 values (99,99); select * from t1;
-- statement above doesn't return row just inserted but wait a few seconds and it will
select * from t1;

-- note also that you wrote an insert on a read replica!!
