alter table products drop constraint products_json_c;

alter table orders drop constraint orders_customer_id_fk ;
                  
alter table orders drop constraint  orders_status_c;
                    
alter table orders drop constraint orders_store_id_fk ;

alter table shipments drop constraint shipments_store_id_fk ;

alter table shipments drop constraint shipments_customer_id_fk ;
                  
alter table shipments drop constraint shipment_status_c;

alter table order_items drop constraint order_items_order_id_fk;

alter table order_items drop constraint order_items_shipment_id_fk;

alter table order_items drop constraint order_items_product_id_fk;
                             
alter table inventory drop constraint inventory_store_id_fk ;

alter table inventory drop constraint inventory_product_id_fk ;
