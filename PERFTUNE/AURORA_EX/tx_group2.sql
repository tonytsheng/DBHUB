\set order_id random(1,10000000) 

BEGIN; 
-- select random orders 
SELECT SUM(order_item.PRICE * order_item.quantity) FROM customer_order , order_item WHERE customer_order.order_id = :order_id AND customer_order.order_id = order_item.order_id; 

--select random order payment 
SELECT customer_order.order_id, order_item.item_description, order_item.quantity, order_payment.amount FROM customer_order , order_item , order_payment WHERE customer_order.order_id = :order_id AND order_item.order_id = customer_order.order_id AND order_payment.order_id = customer_order.order_id; 

END;
