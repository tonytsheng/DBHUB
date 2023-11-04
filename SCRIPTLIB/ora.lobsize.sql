select count(*), (dbms_lob.getlength(order_img))/1024/1024 as SizeMB 
    from customer_orders.orders 
    group by (dbms_lob.getlength(order_img))/1024/1024;

select order_id ,  (dbms_lob.getlength(order_img))/1024/1024 as SizeMB
from customer_orders.orders
where (dbms_lob.getlength(order_img))/1024/1024 > 1;
exit


