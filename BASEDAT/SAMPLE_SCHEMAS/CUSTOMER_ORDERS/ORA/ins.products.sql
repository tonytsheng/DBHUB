insert into products (PRODUCT_ID,PRODUCT_NAME,UNIT_PRICE,PRODUCT_DETAILS) 
values (((select max(product_id) from products) + 1)
	,(select * from (select product_name from products order by dbms_random.value) where rownum <=1)
	, NULL
	, NULL
);
commit;
select count(*) from products;
exit
