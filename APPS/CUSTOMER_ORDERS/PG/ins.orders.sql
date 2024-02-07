insert into customer_orders.orders
(order_id
  , order_datetime
  , customer_id
  , order_status
  , store_id)
values
(
  nextval('customer_orders.seq_orders$def_on_null')
  , now()
  , (select customer_id from customer_orders.customers offset random() * (select count(*) from customer_orders.customers) limit 1)
  , 'OPEN'
  , (select store_id from customer_orders.stores offset random() * (select count(*) from customer_orders.stores) limit 1)
)
;
select pg_sleep(5);

