SELECT n.nspname, c.relname, a.attname
FROM pg_catalog.pg_class c,
pg_catalog.pg_namespace n,
pg_catalog.pg_attribute a
WHERE c.oid = a.attrelid AND NOT a.attisdropped AND
a.atttypid = 'pg_catalog.unknown'::pg_catalog.regtype AND
c.relkind IN ('r','m','c') AND
c.relnamespace = n.oid AND
n.nspname !~ '^pg_temp_' AND
n.nspname !~ '^pg_toast_temp_' AND n.nspname NOT IN ('pg_catalog', 'information_schema');

