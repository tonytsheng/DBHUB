set linesize 200
col owner format a20
col name format a20
col segment_name format a20
SELECT
   owner, "Type", table_name "Name", TRUNC(sum(bytes)/1024/1024) MB
FROM
(  SELECT segment_name table_name, owner, bytes, 'Table' as "Type"
   FROM dba_segments
   WHERE segment_type in  ('TABLE','TABLE PARTITION','TABLE SUBPARTITION')
 UNION ALL
   SELECT i.table_name, i.owner, s.bytes, 'Index' as "Type"
   FROM dba_indexes i, dba_segments s
   WHERE s.segment_name = i.index_name
   AND   s.owner = i.owner
   AND   s.segment_type in ('INDEX','INDEX PARTITION','INDEX SUBPARTITION')
 UNION ALL
   SELECT l.table_name, l.owner, s.bytes, 'LOB' as "Type"
   FROM dba_lobs l, dba_segments s
   WHERE s.segment_name = l.segment_name
   AND   s.owner = l.owner
   AND   s.segment_type IN ('LOBSEGMENT','LOB PARTITION','LOB SUBPARTITION')
 UNION ALL
   SELECT l.table_name, l.owner, s.bytes, 'LOB Index' as "Type"
   FROM dba_lobs l, dba_segments s
   WHERE s.segment_name = l.index_name
   AND   s.owner = l.owner
   AND   s.segment_type = 'LOBINDEX')
   WHERE owner in UPPER('CUSTOMER_ORDERS')
GROUP BY table_name, owner, "Type"
-- HAVING SUM(bytes)/1024/1024 > 10  /* Ignore really small tables */
ORDER BY SUM(bytes) desc;

select segment_name,sum(bytes)/1024/1024 MB 
from dba_segments where segment_type='TABLE' and segment_name=upper('ORDERS') group by segment_name;

exit

