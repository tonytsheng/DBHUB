select to_char(pickup_datetime, 'YYYY-MM-DD') from adb305.ttsheng_nypub where datepart(year,pickup_datetime)=2009;

select datepart(year,pickup_datetime) ,count(*) from adb305.ttsheng_nypub 
group by 1;

select datepart(month,pickup_datetime) ,count(*) from adb305.ttsheng_nypub 
group by 1;

select datepart(day,pickup_datetime) ,count(*) from adb305.ttsheng_nypub
group by 1 order by 1;

