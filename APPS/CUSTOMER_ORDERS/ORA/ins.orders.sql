Insert into ORDERS 
(ORDER_ID,ORDER_DATETIME,CUSTOMER_ID,STORE_ID,ORDER_STATUS, ORDER_IMG) 
values ( order_seq.nextval 
  ,sysdate
  ,3
  ,1
  ,'COMPLETE',
--  (select order_img from orders where order_id=793)
  (select order_img from orders where order_id=695)
);
commit;
select count(*) from orders;
exit;
