-- ------------ Write DROP-TRIGGER-stage scripts -----------

DROP TRIGGER IF EXISTS customers$tr_ind_on_null
ON customer_orders.customers;



DROP TRIGGER IF EXISTS inventory$tr_ind_on_null
ON customer_orders.inventory;



DROP TRIGGER IF EXISTS orders$tr_ind_on_null
ON customer_orders.orders;



DROP TRIGGER IF EXISTS products$tr_ind_on_null
ON customer_orders.products;



DROP TRIGGER IF EXISTS shipments$tr_ind_on_null
ON customer_orders.shipments;



DROP TRIGGER IF EXISTS stores$tr_ind_on_null
ON customer_orders.stores;



-- ------------ Write DROP-FUNCTION-stage scripts -----------

DROP FUNCTION IF EXISTS customer_orders.customers$tr_fn_ind_on_null();



DROP FUNCTION IF EXISTS customer_orders.inventory$tr_fn_ind_on_null();



DROP FUNCTION IF EXISTS customer_orders.orders$tr_fn_ind_on_null();



DROP FUNCTION IF EXISTS customer_orders.products$tr_fn_ind_on_null();



DROP FUNCTION IF EXISTS customer_orders.shipments$tr_fn_ind_on_null();



DROP FUNCTION IF EXISTS customer_orders.stores$tr_fn_ind_on_null();



-- ------------ Write DROP-FOREIGN-KEY-CONSTRAINT-stage scripts -----------

ALTER TABLE customer_orders.inventory DROP CONSTRAINT inventory_product_id_fk;



ALTER TABLE customer_orders.inventory DROP CONSTRAINT inventory_store_id_fk;



ALTER TABLE customer_orders.order_items DROP CONSTRAINT order_items_order_id_fk;



ALTER TABLE customer_orders.order_items DROP CONSTRAINT order_items_product_id_fk;



ALTER TABLE customer_orders.order_items DROP CONSTRAINT order_items_shipment_id_fk;



ALTER TABLE customer_orders.orders DROP CONSTRAINT orders_customer_id_fk;



ALTER TABLE customer_orders.orders DROP CONSTRAINT orders_store_id_fk;



ALTER TABLE customer_orders.shipments DROP CONSTRAINT shipments_customer_id_fk;



ALTER TABLE customer_orders.shipments DROP CONSTRAINT shipments_store_id_fk;



-- ------------ Write DROP-CONSTRAINT-stage scripts -----------

ALTER TABLE customer_orders.customers DROP CONSTRAINT customers_email_u;



ALTER TABLE customer_orders.customers DROP CONSTRAINT customers_pk;



ALTER TABLE customer_orders.inventory DROP CONSTRAINT inventory_pk;



ALTER TABLE customer_orders.inventory DROP CONSTRAINT inventory_store_product_u;



ALTER TABLE customer_orders.order_items DROP CONSTRAINT order_items_pk;



ALTER TABLE customer_orders.order_items DROP CONSTRAINT order_items_product_u;



ALTER TABLE customer_orders.orders DROP CONSTRAINT orders_pk;



ALTER TABLE customer_orders.orders DROP CONSTRAINT orders_status_c;



ALTER TABLE customer_orders.products DROP CONSTRAINT products_pk;



ALTER TABLE customer_orders.shipments DROP CONSTRAINT shipment_status_c;



ALTER TABLE customer_orders.shipments DROP CONSTRAINT shipments_pk;



ALTER TABLE customer_orders.stores DROP CONSTRAINT store_at_least_one_address_c;



ALTER TABLE customer_orders.stores DROP CONSTRAINT store_name_u;



ALTER TABLE customer_orders.stores DROP CONSTRAINT stores_pk;



-- ------------ Write DROP-INDEX-stage scripts -----------

DROP INDEX IF EXISTS customer_orders.customers_name_i;



DROP INDEX IF EXISTS customer_orders.inventory_product_id_i;



DROP INDEX IF EXISTS customer_orders.order_items_shipment_id_i;



DROP INDEX IF EXISTS customer_orders.orders_customer_id_i;



DROP INDEX IF EXISTS customer_orders.orders_store_id_i;



DROP INDEX IF EXISTS customer_orders.shipments_customer_id_i;



DROP INDEX IF EXISTS customer_orders.shipments_store_id_i;



-- ------------ Write DROP-VIEW-stage scripts -----------

DROP VIEW IF EXISTS customer_orders.a_product_orders;



DROP VIEW IF EXISTS customer_orders.customer_order_products;



DROP VIEW IF EXISTS customer_orders.product_orders;



DROP VIEW IF EXISTS customer_orders.product_reviews;



DROP VIEW IF EXISTS customer_orders.store_orders;



-- ------------ Write DROP-TABLE-stage scripts -----------

DROP TABLE IF EXISTS customer_orders.customers;



DROP TABLE IF EXISTS customer_orders.inventory;



DROP TABLE IF EXISTS customer_orders.order_items;



DROP TABLE IF EXISTS customer_orders.orders;



DROP TABLE IF EXISTS customer_orders.products;



DROP TABLE IF EXISTS customer_orders.shipments;



DROP TABLE IF EXISTS customer_orders.stores;



-- ------------ Write DROP-SEQUENCE-stage scripts -----------

DROP SEQUENCE IF EXISTS customer_orders.seq_customers$def_on_null;



DROP SEQUENCE IF EXISTS customer_orders.seq_inventory$def_on_null;



DROP SEQUENCE IF EXISTS customer_orders.seq_orders$def_on_null;



DROP SEQUENCE IF EXISTS customer_orders.seq_products$def_on_null;



DROP SEQUENCE IF EXISTS customer_orders.seq_shipments$def_on_null;



DROP SEQUENCE IF EXISTS customer_orders.seq_stores$def_on_null;



-- ------------ Write DROP-DATABASE-stage scripts -----------

-- ------------ Write CREATE-DATABASE-stage scripts -----------

CREATE SCHEMA IF NOT EXISTS customer_orders;



-- ------------ Write CREATE-SEQUENCE-stage scripts -----------

CREATE SEQUENCE IF NOT EXISTS customer_orders.seq_customers$def_on_null
INCREMENT BY 1
START WITH 393
MAXVALUE 9223372036854775807
MINVALUE 1
NO CYCLE
CACHE 20;



CREATE SEQUENCE IF NOT EXISTS customer_orders.seq_inventory$def_on_null
INCREMENT BY 1
START WITH 567
MAXVALUE 9223372036854775807
MINVALUE 1
NO CYCLE
CACHE 20;



CREATE SEQUENCE IF NOT EXISTS customer_orders.seq_orders$def_on_null
INCREMENT BY 1
START WITH 1951
MAXVALUE 9223372036854775807
MINVALUE 1
NO CYCLE
CACHE 20;



CREATE SEQUENCE IF NOT EXISTS customer_orders.seq_products$def_on_null
INCREMENT BY 1
START WITH 47
MAXVALUE 9223372036854775807
MINVALUE 1
NO CYCLE
CACHE 20;



CREATE SEQUENCE IF NOT EXISTS customer_orders.seq_shipments$def_on_null
INCREMENT BY 1
START WITH 2027
MAXVALUE 9223372036854775807
MINVALUE 1
NO CYCLE
CACHE 20;



CREATE SEQUENCE IF NOT EXISTS customer_orders.seq_stores$def_on_null
INCREMENT BY 1
START WITH 24
MAXVALUE 9223372036854775807
MINVALUE 1
NO CYCLE
CACHE 20;



-- ------------ Write CREATE-TABLE-stage scripts -----------

CREATE TABLE customer_orders.customers(
    customer_id BIGINT NOT NULL,
    email_address CHARACTER VARYING(255) NOT NULL,
    full_name CHARACTER VARYING(255) NOT NULL
)
        WITH (
        OIDS=FALSE
        );


COMMENT ON TABLE customer_orders.customers
     IS 'Details of the people placing orders';


COMMENT ON COLUMN customer_orders.customers.customer_id
     IS 'Auto-incrementing primary key';


COMMENT ON COLUMN customer_orders.customers.email_address
     IS 'The email address the person uses to access the account';


COMMENT ON COLUMN customer_orders.customers.full_name
     IS 'What this customer is called';



CREATE TABLE customer_orders.inventory(
    inventory_id BIGINT NOT NULL,
    store_id NUMERIC(38,0) NOT NULL,
    product_id NUMERIC(38,0) NOT NULL,
    product_inventory NUMERIC(38,0) NOT NULL
)
        WITH (
        OIDS=FALSE
        );


COMMENT ON TABLE customer_orders.inventory
     IS 'Details of the quantity of stock available for products at each location';


COMMENT ON COLUMN customer_orders.inventory.inventory_id
     IS 'Auto-incrementing primary key';


COMMENT ON COLUMN customer_orders.inventory.store_id
     IS 'Which location the goods are located at';


COMMENT ON COLUMN customer_orders.inventory.product_id
     IS 'Which item this stock is for';


COMMENT ON COLUMN customer_orders.inventory.product_inventory
     IS 'The current quantity in stock';



CREATE TABLE customer_orders.order_items(
    order_id NUMERIC(38,0) NOT NULL,
    line_item_id NUMERIC(38,0) NOT NULL,
    product_id NUMERIC(38,0) NOT NULL,
    unit_price NUMERIC(10,2) NOT NULL,
    quantity NUMERIC(38,0) NOT NULL,
    shipment_id NUMERIC(38,0)
)
        WITH (
        OIDS=FALSE
        );


COMMENT ON TABLE customer_orders.order_items
     IS 'Details of which products the customer has purchased in an order';


COMMENT ON COLUMN customer_orders.order_items.order_id
     IS 'The order these products belong to';


COMMENT ON COLUMN customer_orders.order_items.line_item_id
     IS 'An incrementing number, starting at one for each order';


COMMENT ON COLUMN customer_orders.order_items.product_id
     IS 'Which item was purchased';


COMMENT ON COLUMN customer_orders.order_items.unit_price
     IS 'How much the customer paid for one item of the product';


COMMENT ON COLUMN customer_orders.order_items.quantity
     IS 'How many items of this product the customer purchased';


COMMENT ON COLUMN customer_orders.order_items.shipment_id
     IS 'Where this product will be delivered';



CREATE TABLE customer_orders.orders(
    order_id BIGINT NOT NULL,
    order_datetime TIMESTAMP(6) WITHOUT TIME ZONE NOT NULL,
    customer_id NUMERIC(38,0) NOT NULL,
    order_status CHARACTER VARYING(10) NOT NULL,
    store_id NUMERIC(38,0) NOT NULL
)
        WITH (
        OIDS=FALSE
        );


COMMENT ON TABLE customer_orders.orders
     IS 'Details of who made purchases where';


COMMENT ON COLUMN customer_orders.orders.order_id
     IS 'Auto-incrementing primary key';


COMMENT ON COLUMN customer_orders.orders.order_datetime
     IS 'When the order was placed';


COMMENT ON COLUMN customer_orders.orders.customer_id
     IS 'Who placed this order';


COMMENT ON COLUMN customer_orders.orders.order_status
     IS 'What state the order is in. Valid values are:
OPEN - the order is in progress
PAID - money has been received from the customer for this order
SHIPPED - the products have been dispatched to the customer
COMPLETE - the customer has received the order
CANCELLED - the customer has stopped the order
REFUNDED - there has been an issue with the order and the money has been returned to the customer';


COMMENT ON COLUMN customer_orders.orders.store_id
     IS 'Where this order was placed';



CREATE TABLE customer_orders.products(
    product_id BIGINT NOT NULL,
    product_name CHARACTER VARYING(255) NOT NULL,
    unit_price NUMERIC(10,2),
    product_details BYTEA,
    product_image BYTEA,
    image_mime_type CHARACTER VARYING(512),
    image_filename CHARACTER VARYING(512),
    image_charset CHARACTER VARYING(512),
    image_last_updated TIMESTAMP(0) WITHOUT TIME ZONE
)
        WITH (
        OIDS=FALSE
        );


COMMENT ON TABLE customer_orders.products
     IS 'Details of goods that customers can purchase';


COMMENT ON COLUMN customer_orders.products.product_id
     IS 'Auto-incrementing primary key';


COMMENT ON COLUMN customer_orders.products.product_name
     IS 'What a product is called';


COMMENT ON COLUMN customer_orders.products.unit_price
     IS 'The monetary value of one item of this product';


COMMENT ON COLUMN customer_orders.products.product_details
     IS 'Further details of the product stored in JSON format';


COMMENT ON COLUMN customer_orders.products.product_image
     IS 'A picture of the product';


COMMENT ON COLUMN customer_orders.products.image_mime_type
     IS 'The mime-type of the product image';


COMMENT ON COLUMN customer_orders.products.image_filename
     IS 'The name of the file loaded in the image column';


COMMENT ON COLUMN customer_orders.products.image_charset
     IS 'The character set used to encode the image';


COMMENT ON COLUMN customer_orders.products.image_last_updated
     IS 'The date the image was last changed';



CREATE TABLE customer_orders.shipments(
    shipment_id BIGINT NOT NULL,
    store_id NUMERIC(38,0) NOT NULL,
    customer_id NUMERIC(38,0) NOT NULL,
    delivery_address CHARACTER VARYING(512) NOT NULL,
    shipment_status CHARACTER VARYING(100) NOT NULL
)
        WITH (
        OIDS=FALSE
        );


COMMENT ON TABLE customer_orders.shipments
     IS 'Details of where ordered goods will be delivered';


COMMENT ON COLUMN customer_orders.shipments.shipment_id
     IS 'Auto-incrementing primary key';


COMMENT ON COLUMN customer_orders.shipments.store_id
     IS 'Which location the goods will be transported from';


COMMENT ON COLUMN customer_orders.shipments.customer_id
     IS 'Who this shipment is for';


COMMENT ON COLUMN customer_orders.shipments.delivery_address
     IS 'Where the goods will be transported to';


COMMENT ON COLUMN customer_orders.shipments.shipment_status
     IS 'The current status of the shipment. Valid values are:
CREATED - the shipment is ready for order assignment
SHIPPED - the goods have been dispatched
IN-TRANSIT - the goods are en-route to their destination
DELIVERED - the good have arrived at their destination';



CREATE TABLE customer_orders.stores(
    store_id BIGINT NOT NULL,
    store_name CHARACTER VARYING(255) NOT NULL,
    web_address CHARACTER VARYING(100),
    physical_address CHARACTER VARYING(512),
    latitude DOUBLE PRECISION,
    longitude DOUBLE PRECISION,
    logo BYTEA,
    logo_mime_type CHARACTER VARYING(512),
    logo_filename CHARACTER VARYING(512),
    logo_charset CHARACTER VARYING(512),
    logo_last_updated TIMESTAMP(0) WITHOUT TIME ZONE
)
        WITH (
        OIDS=FALSE
        );


COMMENT ON TABLE customer_orders.stores
     IS 'Physical and virtual locations where people can purchase products';


COMMENT ON COLUMN customer_orders.stores.store_id
     IS 'Auto-incrementing primary key';


COMMENT ON COLUMN customer_orders.stores.store_name
     IS 'What the store is called';


COMMENT ON COLUMN customer_orders.stores.web_address
     IS 'The URL of a virtual store';


COMMENT ON COLUMN customer_orders.stores.physical_address
     IS 'The postal address of this location';


COMMENT ON COLUMN customer_orders.stores.latitude
     IS 'The north-south position of a physical store';


COMMENT ON COLUMN customer_orders.stores.longitude
     IS 'The east-west position of a physical store';


COMMENT ON COLUMN customer_orders.stores.logo
     IS 'An image used by this store';


COMMENT ON COLUMN customer_orders.stores.logo_mime_type
     IS 'The mime-type of the store logo';


COMMENT ON COLUMN customer_orders.stores.logo_filename
     IS 'The name of the file loaded in the image column';


COMMENT ON COLUMN customer_orders.stores.logo_charset
     IS 'The character set used to encode the image';


COMMENT ON COLUMN customer_orders.stores.logo_last_updated
     IS 'The date the image was last changed';



-- ------------ Write CREATE-VIEW-stage scripts -----------

CREATE OR REPLACE VIEW customer_orders.a_product_orders (product_name, order_status, total_sales, order_count) AS
SELECT
    p.product_name, o.order_status, SUM(oi.quantity * oi.unit_price) AS total_sales, COUNT(*) AS order_count
    FROM customer_orders.orders AS o
    JOIN customer_orders.order_items AS oi
        ON o.order_id = oi.order_id
    JOIN customer_orders.customers AS c
        ON o.customer_id = c.customer_id
    JOIN customer_orders.products AS p
        ON oi.product_id = p.product_id
    GROUP BY p.product_name, o.order_status;



CREATE OR REPLACE VIEW customer_orders.customer_order_products (order_id) AS
/*
[9996 - Severity CRITICAL - Transformer error occurred. Please submit report to developers.]
select o.order_id, o.order_datetime, o.order_status,
         c.customer_id, c.email_address, c.full_name,
         sum ( oi.quantity * oi.unit_price ) order_total,
         listagg
*/
BEGIN
END;


COMMENT ON view customer_orders.customer_order_products
    IS 'A summary of who placed each order and what they bought';



CREATE OR REPLACE VIEW customer_orders.product_orders (product_name, order_status, total_sales, order_count) AS
SELECT
    p.product_name, o.order_status, SUM(oi.quantity * oi.unit_price) AS total_sales, COUNT(*) AS order_count
    FROM customer_orders.orders AS o
    JOIN customer_orders.order_items AS oi
        ON o.order_id = oi.order_id
    JOIN customer_orders.customers AS c
        ON o.customer_id = c.customer_id
    JOIN customer_orders.products AS p
        ON oi.product_id = p.product_id
    GROUP BY p.product_name, o.order_status;


COMMENT ON view customer_orders.product_orders
    IS 'A summary of the state of the orders placed for each product';



CREATE OR REPLACE VIEW customer_orders.product_reviews (text, error_msg) AS
SELECT 'CREATE OR REPLACE FORCE VIEW CUSTOMER_ORDERS.PRODUCT_REVIEWS(PRODUCT_NAME, RATING, AVG_RATING, REVIEW) AS 
select p.product_name, r.rating,
         round (
           avg ( r.rating ) over (
             partition by product_name
           ),
           2
         ) avg_rating,
         r.review
  from   products p,
         json_table (
           p.product_details, ''$''
           columns (
             nested path ''$.reviews[*]''
             columns (
               rating integer path ''$.rating'',
               review varchar2(4000) path ''$.review''
             )
           )
         ) r;'::varchar AS text,'9996 - Severity CRITICAL - Transformer error occurred. Please submit report to developers.
'::varchar AS error_msg;


COMMENT ON view customer_orders.product_reviews
    IS 'A relational view of the reviews stored in the JSON for each product';



CREATE OR REPLACE VIEW customer_orders.store_orders (text, error_msg) AS
SELECT 'CREATE OR REPLACE FORCE VIEW CUSTOMER_ORDERS.STORE_ORDERS(TOTAL, STORE_NAME, ADDRESS, LATITUDE, LONGITUDE, ORDER_STATUS, ORDER_COUNT, TOTAL_SALES) AS 
select case
           grouping_id ( store_name, order_status )
           when 1 then ''STORE TOTAL''
           when 2 then ''STATUS TOTAL''
           when 3 then ''GRAND TOTAL''
         end total,
         s.store_name,
         coalesce ( s.web_address, s.physical_address ) address,
         s.latitude, s.longitude,
         o.order_status,
         count ( distinct o.order_id ) order_count,
         sum ( oi.quantity * oi.unit_price ) total_sales
  from   stores s
  join   orders o
  on     s.store_id = o.store_id
  join   order_items oi
  on     o.order_id = oi.order_id
  group  by grouping sets (
    ( s.store_name, coalesce ( s.web_address, s.physical_address ), s.latitude, s.longitude ),
    ( s.store_name, coalesce ( s.web_address, s.physical_address ), s.latitude, s.longitude, o.order_status ),
    o.order_status,
    ()
  );'::varchar AS text,'5340 - Severity CRITICAL - PostgreSQL doesn''t support the GROUPING_ID(<VARIABLE_ARGUMENTS>) function. Use suitable function or create user defined function.
5578 - Severity CRITICAL - Unable to automatically transform the SELECT statement. Try rewriting the statement.
'::varchar AS error_msg;


COMMENT ON view customer_orders.store_orders
    IS 'A summary of what was purchased at each location, including summaries each store, order status and overall total';



-- ------------ Write CREATE-INDEX-stage scripts -----------

CREATE INDEX customers_name_i
ON customer_orders.customers
USING BTREE (full_name ASC);



CREATE INDEX inventory_product_id_i
ON customer_orders.inventory
USING BTREE (product_id ASC);



CREATE INDEX order_items_shipment_id_i
ON customer_orders.order_items
USING BTREE (shipment_id ASC);



CREATE INDEX orders_customer_id_i
ON customer_orders.orders
USING BTREE (customer_id ASC);



CREATE INDEX orders_store_id_i
ON customer_orders.orders
USING BTREE (store_id ASC);



CREATE INDEX shipments_customer_id_i
ON customer_orders.shipments
USING BTREE (customer_id ASC);



CREATE INDEX shipments_store_id_i
ON customer_orders.shipments
USING BTREE (store_id ASC);



-- ------------ Write CREATE-CONSTRAINT-stage scripts -----------

ALTER TABLE customer_orders.customers
ADD CONSTRAINT customers_email_u UNIQUE (email_address);



ALTER TABLE customer_orders.customers
ADD CONSTRAINT customers_pk PRIMARY KEY (customer_id);



ALTER TABLE customer_orders.inventory
ADD CONSTRAINT inventory_pk PRIMARY KEY (inventory_id);



ALTER TABLE customer_orders.inventory
ADD CONSTRAINT inventory_store_product_u UNIQUE (store_id, product_id);



ALTER TABLE customer_orders.order_items
ADD CONSTRAINT order_items_pk PRIMARY KEY (order_id, line_item_id);



ALTER TABLE customer_orders.order_items
ADD CONSTRAINT order_items_product_u UNIQUE (product_id, order_id);



ALTER TABLE customer_orders.orders
ADD CONSTRAINT orders_pk PRIMARY KEY (order_id);



ALTER TABLE customer_orders.orders
ADD CONSTRAINT orders_status_c CHECK (order_status IN ('CANCELLED', 'COMPLETE', 'OPEN', 'PAID', 'REFUNDED', 'SHIPPED'));



ALTER TABLE customer_orders.products
ADD CONSTRAINT products_pk PRIMARY KEY (product_id);



ALTER TABLE customer_orders.shipments
ADD CONSTRAINT shipment_status_c CHECK (shipment_status IN ('CREATED', 'SHIPPED', 'IN-TRANSIT', 'DELIVERED'));



ALTER TABLE customer_orders.shipments
ADD CONSTRAINT shipments_pk PRIMARY KEY (shipment_id);



ALTER TABLE customer_orders.stores
ADD CONSTRAINT store_at_least_one_address_c CHECK (web_address IS NOT NULL OR physical_address IS NOT NULL);



-- ALTER TABLE customer_orders.stores
-- ADD CONSTRAINT store_name_u UNIQUE (store_name);



ALTER TABLE customer_orders.stores
ADD CONSTRAINT stores_pk PRIMARY KEY (store_id);



-- ------------ Write CREATE-FOREIGN-KEY-CONSTRAINT-stage scripts -----------

ALTER TABLE customer_orders.inventory
ADD CONSTRAINT inventory_product_id_fk FOREIGN KEY (product_id) 
REFERENCES customer_orders.products (product_id)
ON DELETE NO ACTION;



ALTER TABLE customer_orders.inventory
ADD CONSTRAINT inventory_store_id_fk FOREIGN KEY (store_id) 
REFERENCES customer_orders.stores (store_id)
ON DELETE NO ACTION;



ALTER TABLE customer_orders.order_items
ADD CONSTRAINT order_items_order_id_fk FOREIGN KEY (order_id) 
REFERENCES customer_orders.orders (order_id)
ON DELETE NO ACTION;



ALTER TABLE customer_orders.order_items
ADD CONSTRAINT order_items_product_id_fk FOREIGN KEY (product_id) 
REFERENCES customer_orders.products (product_id)
ON DELETE NO ACTION;



ALTER TABLE customer_orders.order_items
ADD CONSTRAINT order_items_shipment_id_fk FOREIGN KEY (shipment_id) 
REFERENCES customer_orders.shipments (shipment_id)
ON DELETE NO ACTION;



ALTER TABLE customer_orders.orders
ADD CONSTRAINT orders_customer_id_fk FOREIGN KEY (customer_id) 
REFERENCES customer_orders.customers (customer_id)
ON DELETE NO ACTION;



ALTER TABLE customer_orders.orders
ADD CONSTRAINT orders_store_id_fk FOREIGN KEY (store_id) 
REFERENCES customer_orders.stores (store_id)
ON DELETE NO ACTION;



ALTER TABLE customer_orders.shipments
ADD CONSTRAINT shipments_customer_id_fk FOREIGN KEY (customer_id) 
REFERENCES customer_orders.customers (customer_id)
ON DELETE NO ACTION;



ALTER TABLE customer_orders.shipments
ADD CONSTRAINT shipments_store_id_fk FOREIGN KEY (store_id) 
REFERENCES customer_orders.stores (store_id)
ON DELETE NO ACTION;



-- ------------ Write CREATE-FUNCTION-stage scripts -----------

CREATE OR REPLACE FUNCTION customer_orders.customers$tr_fn_ind_on_null()
RETURNS trigger
AS
$BODY$
BEGIN
   New.customer_id := nextval('seq_customers$def_on_null');
   RETURN NEW;
END;
$BODY$
LANGUAGE  plpgsql;



CREATE OR REPLACE FUNCTION customer_orders.inventory$tr_fn_ind_on_null()
RETURNS trigger
AS
$BODY$
BEGIN
   New.inventory_id := nextval('seq_inventory$def_on_null');
   RETURN NEW;
END;
$BODY$
LANGUAGE  plpgsql;



CREATE OR REPLACE FUNCTION customer_orders.orders$tr_fn_ind_on_null()
RETURNS trigger
AS
$BODY$
BEGIN
   New.order_id := nextval('seq_orders$def_on_null');
   RETURN NEW;
END;
$BODY$
LANGUAGE  plpgsql;



CREATE OR REPLACE FUNCTION customer_orders.products$tr_fn_ind_on_null()
RETURNS trigger
AS
$BODY$
BEGIN
   New.product_id := nextval('seq_products$def_on_null');
   RETURN NEW;
END;
$BODY$
LANGUAGE  plpgsql;



CREATE OR REPLACE FUNCTION customer_orders.shipments$tr_fn_ind_on_null()
RETURNS trigger
AS
$BODY$
BEGIN
   New.shipment_id := nextval('seq_shipments$def_on_null');
   RETURN NEW;
END;
$BODY$
LANGUAGE  plpgsql;



CREATE OR REPLACE FUNCTION customer_orders.stores$tr_fn_ind_on_null()
RETURNS trigger
AS
$BODY$
BEGIN
   New.store_id := nextval('seq_stores$def_on_null');
   RETURN NEW;
END;
$BODY$
LANGUAGE  plpgsql;



-- ------------ Write CREATE-TRIGGER-stage scripts -----------

CREATE TRIGGER customers$tr_ind_on_null
BEFORE INSERT
ON customer_orders.customers
FOR EACH ROW
when (New.CUSTOMER_ID is null)
EXECUTE PROCEDURE customer_orders.customers$tr_fn_ind_on_null();



CREATE TRIGGER inventory$tr_ind_on_null
BEFORE INSERT
ON customer_orders.inventory
FOR EACH ROW
when (New.INVENTORY_ID is null)
EXECUTE PROCEDURE customer_orders.inventory$tr_fn_ind_on_null();



CREATE TRIGGER orders$tr_ind_on_null
BEFORE INSERT
ON customer_orders.orders
FOR EACH ROW
when (New.ORDER_ID is null)
EXECUTE PROCEDURE customer_orders.orders$tr_fn_ind_on_null();



CREATE TRIGGER products$tr_ind_on_null
BEFORE INSERT
ON customer_orders.products
FOR EACH ROW
when (New.PRODUCT_ID is null)
EXECUTE PROCEDURE customer_orders.products$tr_fn_ind_on_null();



CREATE TRIGGER shipments$tr_ind_on_null
BEFORE INSERT
ON customer_orders.shipments
FOR EACH ROW
when (New.SHIPMENT_ID is null)
EXECUTE PROCEDURE customer_orders.shipments$tr_fn_ind_on_null();



CREATE TRIGGER stores$tr_ind_on_null
BEFORE INSERT
ON customer_orders.stores
FOR EACH ROW
when (New.STORE_ID is null)
EXECUTE PROCEDURE customer_orders.stores$tr_fn_ind_on_null();



