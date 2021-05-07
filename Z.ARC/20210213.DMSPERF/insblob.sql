insert into 
customer_orders.stores (store_name, physical_address, logo) 
select 'City', physical_address, logo from customer_orders.stores where store_id=24;
commit;
exit

