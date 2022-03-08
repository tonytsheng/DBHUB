insert into customer_orders.shipments (select max(shipment_id)+1 , 22,33,'ADD1','SHIPPED' from customer_orders.shipments);

