use customer_orders
go
-- ------------ Write CREATE-TABLE-stage scripts -----------

CREATE TABLE customers(
    customer_id BIGINT NOT NULL,
    email_address CHARACTER VARYING(255) NOT NULL,
    full_name CHARACTER VARYING(255) NOT NULL
)
go


CREATE TABLE inventory(
    inventory_id BIGINT NOT NULL,
    store_id NUMERIC(38,0) NOT NULL,
    product_id NUMERIC(38,0) NOT NULL,
    product_inventory NUMERIC(38,0) NOT NULL
)
go


CREATE TABLE order_items(
    order_id NUMERIC(38,0) NOT NULL,
    line_item_id NUMERIC(38,0) NOT NULL,
    product_id NUMERIC(38,0) NOT NULL,
    unit_price NUMERIC(10,2) NOT NULL,
    quantity NUMERIC(38,0) NOT NULL,
    shipment_id NUMERIC(38,0)
)
go



CREATE TABLE orders(
    order_id BIGINT NOT NULL,
    order_datetime TIMESTAMP(6) NOT NULL,
    customer_id NUMERIC(38,0) NOT NULL,
    order_status CHARACTER VARYING(10) NOT NULL,
    store_id NUMERIC(38,0) NOT NULL
)
go


CREATE TABLE products(
    product_id BIGINT NOT NULL,
    product_name CHARACTER VARYING(255) NOT NULL,
    unit_price NUMERIC(10,2),
    product_details BYTEA,
    product_image BYTEA,
    image_mime_type CHARACTER VARYING(512),
    image_filename CHARACTER VARYING(512),
    image_charset CHARACTER VARYING(512),
    image_last_updated TIMESTAMP(0) 
)
go


CREATE TABLE shipments(
    shipment_id BIGINT NOT NULL,
    store_id NUMERIC(38,0) NOT NULL,
    customer_id NUMERIC(38,0) NOT NULL,
    delivery_address CHARACTER VARYING(512) NOT NULL,
    shipment_status CHARACTER VARYING(100) NOT NULL
)
go

CREATE TABLE stores(
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
    logo_last_updated TIMESTAMP(0) 
)
go
exit


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



