set pagesize 200
set linesize 200

col table_name format a40
col schema_name format a40
select col.owner as schema_name,
col.table_name,
count(*) as column_count
from sys.dba_tab_columns col
inner join sys.dba_tables t on col.owner = t.owner
and col.table_name = t.table_name
where col.data_type in ('BLOB', 'CLOB', 'NCLOB', 'BFILE')
-- excluding some Oracle maintained schemas
and col.owner not in ('ANONYMOUS','CTXSYS','DBSNMP','EXFSYS', 'LBACSYS',
'MDSYS', 'MGMT_VIEW','OLAPSYS','OWBSYS','ORDPLUGINS', 'ORDSYS','OUTLN',
'SI_INFORMTN_SCHEMA','SYS','SYSMAN','SYSTEM', 'TSMSYS','WK_TEST',
'WKPROXY','WMSYS','XDB','APEX_040000', 'APEX_PUBLIC_USER','DIP', 'WKSYS',
'FLOWS_30000','FLOWS_FILES','MDDATA', 'ORACLE_OCM', 'XS$NULL',
'SPATIAL_CSW_ADMIN_USR', 'SPATIAL_WFS_ADMIN_USR', 'PUBLIC')
group by col.owner,
col.table_name
order by col.owner,
col.table_name;
exit

