pgbench -i -s 5000 -d pg102 -h pg102.cyt4dgtj55oy.us-east-2.rds.amazonaws.com -p 5432 -U postgres

select count(bid) from pgbench_branches b 
          where not exists 
                (select 1 from pgbench_accounts a where a.bid=b.bid);



EXPLAIN SELECT * FROM foo;
