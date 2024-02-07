SELECT * FROM (SELECT product_id, product_name, image_last_updated FROM customer_orders.products where image_last_updated is not NULL ORDER BY IMAGE_LAST_UPDATED DESC
 LIMIT 10) h1 ORDER BY IMAGE_LAST_UPDATED desc;
select count(*) from customer_orders.products;
select pg_sleep(2);
\q

