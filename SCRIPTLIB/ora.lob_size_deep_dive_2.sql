prompt
prompt
prompt
prompt This script will perform a deep dive to work out the size of any blobs in your specified schema.
prompt
prompt
accept v_schema_name prompt "Please enter your schema name: (default %): " DEFAULT %
prompt
accept v_table_name prompt "Please enter your Table name: (default %): " DEFAULT %
prompt
accept v_column_name prompt "Please enter your column name: (default %): " DEFAULT %
prompt
drop table dms_lob_deep_dive;
create table dms_lob_deep_dive as
select /*+ FULL(t) PARALLEL(t, 6) */
WIDTH_BUCKET(dbms_lob.getlength(t.&v_column_name), 1024, 65536000, 1000) bucket,
min(dbms_lob.getlength(t.&v_column_name)) min_byte_size,
max(dbms_lob.getlength(t.&v_column_name)) max_byte_size,
round(avg(dbms_lob.getlength(t.&v_column_name))) avg_byte_size,
sum(dbms_lob.getlength(t.&v_column_name) ) total_bytes,
-- round((sum(dbms_lob.getlength(t.&v_column_name))) over (), 2) total_bytes_cumlative,
-- SUM(dbms_lob.getlength(t.&v_column_name)) OVER (ORDER BY *, dbms_lob.getlength(t.&v_column_name) ) CUMTOT,
count(*) row_count,
round(100*ratio_to_report(count(*)) over (), 2) "% ROWS",
-- round(100*ratio_to_report(sum(dbms_lob.getlength(t.&v_column_name)) over (), 2) "% LOB DATA",
round(100*ratio_to_report(sum(dbms_lob.getlength(t.&v_column_name))) over (), 2) "% LOB DATA"
from &v_schema_name..&v_table_name t
where dbms_lob.getlength(t. &v_column_name) > 1
group by WIDTH_BUCKET(dbms_lob.getlength(t.&v_column_name), 1024, 65536000, 1000)
order by 1;
set pagesize 300
set linesize 220

-- Report
-- THIS ONE...
column TOTAL_BYTES format 999999999999999
column "Cumulative % of total rows" head "Cumulative % |of total rows"
column "Cumulative % of total bytes" head "Cumulative % |of total bytes"
column ROW_COUNT format 99999999999999

select a.BUCKET,a.MIN_BYTE_SIZE,a.MAX_BYTE_SIZE,a.AVG_BYTE_SIZE,round(a.TOTAL_BYTES/1024/1024) TOTAL_MEGS,a.ROW_COUNT,a."% ROWS",a."% LOB DATA" ,
round((SUM(b.ROW_COUNT)/(SELECT SUM(ROW_COUNT) FROM dms_lob_deep_dive) * 100),2) "Cumulative % of total rows",
round((SUM(b.TOTAL_BYTES)/(SELECT SUM(TOTAL_BYTES) FROM dms_lob_deep_dive) * 100),2) "Cumulative % of total bytes"
from dms_lob_deep_dive a, dms_lob_deep_dive b
where a.BUCKET >= b.BUCKET
group by a.BUCKET,a.MIN_BYTE_SIZE,a.MAX_BYTE_SIZE,a.AVG_BYTE_SIZE,a.TOTAL_BYTES,a.ROW_COUNT,a."% ROWS",a."% LOB DATA"
order by bucket;
exit

