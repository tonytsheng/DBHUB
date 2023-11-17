select to_char(pickup_datetime, 'YYYY-MM-DD') from adb305.ttsheng_nypub where datepart(year,pickup_datetime)=2009;

select datepart(year,pickup_datetime) ,count(*) from adb305.ttsheng_nypub 
group by 1;

select datepart(month,pickup_datetime) ,count(*) from adb305.ttsheng_nypub 
group by 1;

select datepart(day,pickup_datetime) ,count(*) from adb305.ttsheng_nypub
group by 1 order by 1;

SELECT * FROM table ORDER BY index LIMIT 100 OFFSET 300
-- read 100 rows but skip first 300

-- Table partitioning is not supported, instead create granular tables and union
