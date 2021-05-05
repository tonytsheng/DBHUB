set linesize 200
col segment_name format a30
select segment_name,sum(bytes)/1024/1024/1024 GB 
from dba_segments 
where segment_type='TABLE' 
and segment_name=upper('STORES') 
group by segment_name; 
