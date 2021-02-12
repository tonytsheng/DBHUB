/**
DECLARE
v1 NUMBER;
BEGIN
v1:=DBMS_DATAPUMP.ATTACH('SYS_IMPORT_SCHEMA_01','ROOT');
DBMS_DATAPUMP.STOP_JOB (v1,1,0);
END;
/
**/

set serveroutput on;
begin
for r in (select job_name, owner_name from dba_datapump_jobs)
loop
    dbms_output.put_line ('DECLARE h1 NUMBER;');
    dbms_output.put_line ('    BEGIN');
    dbms_output.put_line ('    h1 := DBMS_DATAPUMP.ATTACH(''' || r.job_name || ''','''|| r.owner_name || ''');');
    dbms_output.put_line ('    DBMS_DATAPUMP.STOP_JOB (h1,1,0);');
    dbms_output.put_line ('END;');
    dbms_output.put_line ('/');
end loop;
end;
/
exit

