insert into customer_orders.products (PRODUCT_ID,PRODUCT_NAME,UNIT_PRICE,PRODUCT_DETAILS)
values ( (select (max(product_id))+1 from customer_orders.products)
        ,(  select product_name from customer_orders.products order by random() limit 1)
--	'PRODUCT 1'
        , NULL
        , NULL
);
select count(*) from customer_orders.products;
