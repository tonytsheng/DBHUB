SELECT sql_id, status, rows_processed, time_remaining,plan_hash_value, sql_text,degree, instances,executions, rows_processed, elapsed_time
FROM V$SQL
WHERE parallel = 'YES'
ORDER BY time_remaining;

-- With SELECT statement:
SELECT /*+ parallel(4) */ ...

-- With INSERT statement:
INSERT /*+ parallel(8) */ INTO ...

-- With CREATE INDEX statement:
CREATE /*+ parallel(2) */ INDEX ...

-- With UPDATE statement:
UPDATE /*+ parallel(6) */ ...

-- With DELETE statement:
DELETE /*+ parallel(8) */ ...

-- With MERGE statement:
MERGE /*+ parallel(4) */ INTO ...

-- With ALTER TABLE statement:
ALTER /*+ parallel(8) */ TABLE ...

-- With ANALYZE statement:
ANALYZE /*+ parallel(4) */ ...
