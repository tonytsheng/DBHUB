col "SID/SERIAL" format a10
col username format a15
col osuser format a15
col program format a40
select s.sid || ',' || s.serial# "SID/SERIAL" , s.username , s.osuser , p.spid "OS PID" , s.program
from v$session s , v$process p Where s.paddr = p.addr order by to_number(p.spid);

-- SQL USED BY AS SESSION:
select sql.sql_text
from v$session ses, v$sqltext sql
where sql.address=ses.sql_address
and sql.hash_value=ses.sql_hash_value
and sid=&sess_id
order by piece;

-- IDENTIFYING THE OBJECTS ACCESSED BY A SESSION:
select owner, object, type from v$access
where sid=&sess_id
and owner not in ('SYS','SYSTEM');

-- IDENTIFYING SID OF CLIENT PROCESS ID:
select sid from v$session
where process='&client_pid';

-- IDENTIFYING SID OF SERVER PROCESS ID:
select sid
from v$session
where paddr in (select addr from v$process
where background is null and spid=&Server_pid);

-- IDENTIFYING THE SERVER PROCESS ID USING ORACLE SID:
select spid
from v$process
where background is null
and addr in (select paddr from v$session where sid=&sess_id);

-- IDENTIFYING SESSIONS INACTIVE FOR MORE THAN 1 HOURS:
select sid
from v$session
where paddr in (select addr
from v$process
where background is null)
and status='INACTIVE'and last_call_et/60/60>1;

-- WAIT EVENTS FOR A SESSION:
select p1, p2, p3, event
from v$session_wait
where sid=&sess_id;

- IDENTIFYING THE PARALLEL SESSIONS:
Select qcsid, sid
from v$px_session
where qcsid=&session_id;

- CONCURRENT USER SESSIONS:
select SESSIONS_HIGHWATER, SESSIONS_MAX from v$license;

-- SESSION_HIGHWATER = Highest number of concurrent user sessions since the instance started.
-- SESSIONS_MAX = Maximum number of concurrent user sessions allowed for the instance

-- PGA USAGE BY USERS:
select st.sid "SID", sn.name "TYPE",ceil(st.value / 1024 / 1024) "MB"
from v$sesstat st, v$statname sn
where st.statistic# = sn.statistic#
and sid in (select sid from v$session
where username like '&user')
and upper(sn.name) like '%PGA%'
order by st.sid,
st.value desc;

-- IDENTIFYING LOCKED OBJECTS:
set linesize 1000
set pagesize 5000
select substr(do.OBJECT_NAME,1,30) as locked_Object,
lo.locked_mode as Lock_Mode,
lo.SESSION_ID as SessionId,
lo.ORACLE_USERNAME,
to_char(ss.LOGON_TIME,'DD-MM-YYYY HH24:MI:SS') as "Login At",
substr(ss.OSUSER,1,15) as Os_User,
'alter system kill session '||concat(concat("",SID||','||serial#),"")||';' as "COMMAND_to_KILL_SESSION"
from dba_objects do, v$locked_object lo , v$session ss
where do.OBJECT_ID=lo.OBJECT_ID
and lo.session_id=ss.SID
order by 5;

-- IDENTIFYING GIVEN OBJECT FOR LOCK:
select substr(do.OBJECT_NAME,1,30) as locked_Object,
lo.locked_mode as Lock_Mode,
lo.SESSION_ID as SessionId,
lo.ORACLE_USERNAME,
to_char(ss.LOGON_TIME, 'DD-MM-YYYY HH24:MI:SS') as "Login At",
substr(ss.OSUSER,1,15) as Os_User,
'alter system kill session '||concat(concat("",SID||','||serial#),"")||';' as "COMMAND_to_KILL_SESSION"
from dba_objects do, v$locked_object lo , v$session ss
where do.OBJECT_ID=lo.OBJECT_ID
and lo.session_id=ss.SID and substr(do.OBJECT_NAME,1,30)='&objn'
order by 5;

 


