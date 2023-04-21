select count(*) customer from customer_orders.customers;
select count(*) stores from customer_orders.stores;
select count(*) products from customer_orders.products;
select count(*) orders from customer_orders.orders;
select count(*) shipments from customer_orders.shipments;
select count(*) order_items from customer_orders.order_items;
select count(*) inventory from customer_orders.inventory;

select * from customer_orders.orders order by order_datetime desc limit 5;
select count(*) from customer_orders.orders ;

