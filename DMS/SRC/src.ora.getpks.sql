set linesize 200
col schema_name format a20
col owner format a20
col table_name format a20
col column_name format a20
select
   all_cons_columns.owner as schema_name,
   all_cons_columns.table_name, 
   all_cons_columns.column_name, 
   all_cons_columns.position, 
   all_constraints.status
from all_constraints, all_cons_columns 
where 
   all_constraints.constraint_type = 'P'
   and all_constraints.constraint_name = all_cons_columns.constraint_name
   and all_constraints.owner = all_cons_columns.owner
  and all_constraints.owner='CUSTOMER_ORDERS'
order by 
   all_cons_columns.owner,
   all_cons_columns.table_name, 
   all_cons_columns.position;

