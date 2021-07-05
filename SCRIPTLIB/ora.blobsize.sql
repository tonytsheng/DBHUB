select count(*)
, (dbms_lob.getlength(order_img))/1024/1024 as SizeMB 
from customer_orders.orders 
group by (dbms_lob.getlength(order_img))/1024/1024;
select count(*)
, (dbms_lob.getlength(logo))/1024/1024 as SizeMB 
from customer_orders.stores 
group by (dbms_lob.getlength(logo))/1024/1024;
exit;

