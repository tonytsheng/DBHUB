set serveroutput on;
SELECT index_name, status FROM user_indexes where status !='VALID';

begin
for r in (SELECT index_name, status FROM user_indexes where status !='VALID')
loop
dbms_output.put_line ('working on ' || r.index_name );
execute immediate 'alter index ' || r.index_name || ' rebuild online';
end loop;
end;
/

SELECT index_name, status FROM user_indexes where status !='VALID';

exit

