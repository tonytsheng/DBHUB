-- Generate a call to the write_csv stored proc for each table in a given schema
-- Execute this output as needed

set serveroutput on
declare v_sql varchar(4000);

begin
  for t in (select table_name from dba_tables where owner='CUSTOMER_ORDERS') 
  loop
    v_sql := 'exec write_csv(''CUSTOMER_ORDERS.' || t.table_name || ''', ''CSV_DIR'', ''' || t.table_name || '.csv'')  ';
    dbms_output.put_line (v_sql);
  end loop;
end;
/
exit

