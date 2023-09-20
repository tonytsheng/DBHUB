https://www.citusdata.com/blog/2022/07/28/debugging-postgres-autovacuum-problems-13-tips/

SELECT relname, last_autovacuum, autovacuum_count, vacuum_count 
FROM pg_stat_user_tables;

