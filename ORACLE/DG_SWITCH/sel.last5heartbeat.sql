set linesize 200
set pagesize 0

SELECT *
  FROM (SELECT *
          FROM heartbeat
         ORDER
            BY last_update DESC
       )
  WHERE ROWNUM <= 5 ORDER BY ROWNUM DESC;

exit;
