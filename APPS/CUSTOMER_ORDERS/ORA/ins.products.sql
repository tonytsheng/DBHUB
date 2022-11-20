insert into customer_orders.products (PRODUCT_ID,PRODUCT_NAME,UNIT_PRICE,PRODUCT_DETAILS) 
values (((select max(product_id) from customer_orders.products) + 1)
	,(select * from (select product_name from customer_orders.products order by dbms_random.value) where rownum <=1)
	, NULL
	, NULL
);
commit;
select count(*) from customer_orders.products;
exit
