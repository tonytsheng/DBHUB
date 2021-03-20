select col.owner as schema_name,
       col.table_name, 
       count(*) as column_count
from sys.all_tab_columns col
inner join sys.all_tables t on col.owner = t.owner 
                              and col.table_name = t.table_name
where col.data_type in ('BLOB', 'CLOB', 'NCLOB', 'BFILE')
and col.owner in ('USERSCHEMA') 
group by col.owner,
         col.table_name
order by col.owner, 
         col.table_name;

