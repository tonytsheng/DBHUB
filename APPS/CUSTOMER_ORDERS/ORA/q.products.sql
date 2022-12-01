set linesize 200;
set pagesize 25;
col product_id format 999999;
col product_name format a20;
col image_last_updated format a30;
alter session set nls_date_format = 'MM/DD/YYYY HH24:MI:SS';
select * from 
(select PRODUCT_ID,PRODUCT_NAME, IMAGE_LAST_UPDATED from products where image_last_updated is not null 
	order by IMAGE_LAST_UPDATED desc) h1  
where rownum <=10 order by rownum;  

select count(*) from orders;
exit

