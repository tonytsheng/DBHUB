select t.owner as schema_name,
       t.table_name
from sys.all_tables t
left join sys.all_constraints c
          on t.owner = c.owner
          and t.table_name = c.table_name
          and c.constraint_type = 'P'
where c.constraint_type is null
and owner like ('UAC%')
order by t.owner,
         t.table_name;
