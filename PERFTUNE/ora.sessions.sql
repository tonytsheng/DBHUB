set linesize 200
col username format a30
col status format a30
select username , COMMAND, status from v$session
where username is not null;
exit

