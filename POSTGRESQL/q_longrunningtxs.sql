SELECT pid, datname, application_name, state, 
age(query_start, clock_timestamp()), usename, query 
FROM pg_stat_activity 
WHERE query NOT ILIKE '%pg_stat_activity%' AND 
usename!='rdsadmin' 
ORDER BY query_start desc;

