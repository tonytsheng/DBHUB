col "Tablespace" for a22
col "Used MB" for 99,999,999
col "Free MB" for 99,999,999
col "Total MB" for 99,999,999

select df.tablespace_name "Tablespace",
totalusedspace "Used MB",
(df.totalspace - tu.totalusedspace) "Free MB",
df.totalspace "Total MB",
round(100 * ( (df.totalspace - tu.totalusedspace)/ df.totalspace))
"Pct. Free"
from
(select tablespace_name,
round(sum(bytes) / 1048576) TotalSpace
from dba_data_files
group by tablespace_name) df,
(select round(sum(bytes)/(1024*1024)) totalusedspace, tablespace_name
from dba_segments
group by tablespace_name) tu
where df.tablespace_name = tu.tablespace_name ;

--
-- Segment Space Usage by Owner
--

CLEAR BREAKS
CLEAR COLUMNS
CLEAR COMPUTES

SET PAGESIZE 60
SET PAUSE ON
SET PAUSE 'Press Return to Continue'
SET VERIFY OFF

COL owner HEA "Owner" FOR a7
COL segment_name HEA "Name" FOR a20 TRUNC
COL segment_type HEA "Type" FOR a7

COL tablespace_name HEA "Tablespace" FOR a10 TRUNC
COL mbytes HEA "Mbytes" FOR 9999.999
COL extents HEA "Extents" FOR 9999

BREAK ON owner ON tablespace_name ON segment_type ON REPORT

COMPUTE SUM OF mbytes ON REPORT

SELECT owner, segment_type, tablespace_name, segment_name,
        ( bytes/1048576 ) mbytes, extents
FROM dba_segments
WHERE owner = UPPER( '&OwnerName' )
ORDER BY owner, tablespace_name, segment_type, segment_name;

col owner for a7
col SEGMENT_TYPE for a7
col TABLE_NAME for a25
col NEXT(KB) for 9,999,990

SELECT s.owner, s.segment_type, t.table_name,
t.max_extents, t.next_extent/1024 "NEXT(KB)", s.extents
FROM dba_tables t, dba_segments s
WHERE t.table_name=s.segment_name
and t.owner not like 'SYS%'
-- and s.extents > 100
union all
SELECT s.owner, s.segment_type, i.index_name,
i.max_extents, i.next_extent/1024 "NEXT(KB)", s.extents
FROM dba_indexes i, dba_segments s
WHERE i.index_name=s.segment_name
and i.owner not like 'SYS%';
-- and s.extents > 100;
select table_name,COLUMN_NAME,SEGMENT_NAME,TABLESPACE_NAME from dba_lobs where OWNER='USERS';

-- ALTER TABLE table_name MOVE LOB(lob-col) STORE AS (TABLESPACE new_tablespace_name);
exit

