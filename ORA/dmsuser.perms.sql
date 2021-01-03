begin
for r in (select table_name from user_tables)
loop
    execute immediate 'grant all on ' || r.table_name || ' to dmsuser';
end loop;
end;
/
exit;
