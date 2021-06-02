select count(*)
, (dbms_lob.getlength(logo))/1024/1024 as SizeMB 
from customer_orders.stores 
group by (dbms_lob.getlength(logo))/1024/1024;

