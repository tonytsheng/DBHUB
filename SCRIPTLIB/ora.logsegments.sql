col owner for a6
col segment_name for a26
select * from
(select owner,segment_name||'~'||partition_name segment_name,segment_type,bytes/(1024*1024) size_m
from dba_segments
ORDER BY BLOCKS desc) where rownum < 11;
