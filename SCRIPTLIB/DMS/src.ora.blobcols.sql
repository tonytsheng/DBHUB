set linesize 200
col schema_name format a20
col table_name format a20
col column_name format a20
set serveroutput on

begin
for r in (select col.owner as schema_name, col.table_name, col.column_name from sys.all_tab_columns col
inner join sys.all_tables t on col.owner = t.owner 
                              and col.table_name = t.table_name
where col.data_type in ('BLOB', 'CLOB', 'NCLOB', 'BFILE')
and col.owner in ('CUSTOMER_ORDERS') ) 
loop
dbms_output.put_line ('select count(*), (dbms_lob.getlength(' || r.column_name || '))/1024/1024 as SizeMB from ' || r.schema_name ||'.'||r.table_name ||  ' group by (dbms_lob.getlength( ' || r.column_name || '))/1024/1024;'); 
end loop;
end;
/
exit

