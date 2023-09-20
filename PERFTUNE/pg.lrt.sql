SELECT now()-query_start as Running_Since
  , pid
  , datname
  , usename
  , application_name
  , client_addr 
  , left(query,60) 
FROM pg_stat_activity 
WHERE state in ('active','idle in transaction') 
  AND (now() - query_start) > interval '5 minutes';
