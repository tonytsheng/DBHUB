set linesize 200
set pagesize 0
select username from dba_users order by 1;
select count(*), owner from dba_objects group by owner order by owner;
exit

