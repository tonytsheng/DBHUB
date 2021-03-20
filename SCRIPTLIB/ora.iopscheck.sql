select METRIC_NAME,avg(AVERAGE) value from dba_hist_sysmetric_summary 
where begin_time between to_date('16-FEB-17 00:00:00', 'dd-MON-yy hh24:mi:ss') 
and to_date('16-FEB-17 23:59:59', 'dd-MON-yy hh24:mi:ss') 
and end_time like '%16-FEB-17%' 
and METRIC_NAME in ('Physical Read Total IO Requests Per Sec','Physical Write Total IO Requests Per Sec') 
group by METRIC_NAME;
