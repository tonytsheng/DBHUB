set linesize 100
column username format a20
column schemaname format a20
SELECT sess.process, sess.status, sess.username, sess.schemaname, sql.sql_text
  FROM v$session sess,
       v$sql     sql
 WHERE sql.sql_id(+) = sess.sql_id
   AND sess.type     = 'USER';
exit;

