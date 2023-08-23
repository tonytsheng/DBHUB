col ts format a20
set linesize 200
set pagesize 0 
select to_char(ORIGINATING_TIMESTAMP, 'MM/DD/YYY HH24:MI:SS') TS, message_text from alertlog
where ORIGINATING_TIMESTAMP > sysdate-(1/24);
exit

