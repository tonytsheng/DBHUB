Select CURRENT_SCN from v$database;
select dbms_flashback.get_system_change_number from dual;
select timestamp_to_scn(sysdate) from dual;
Select sysdate, timestamp_to_scn(sysdate) from dual;
exit

