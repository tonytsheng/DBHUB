CREATE SEQUENCE if not exists order_seq
INCREMENT 1
START 1
MINVALUE 1
MAXVALUE 9223372036854775807
CACHE 1;

CREATE SEQUENCE if not exists order_item_seq
INCREMENT 1
START 1
MINVALUE 1
MAXVALUE 9223372036854775807
CACHE 1;

CREATE SEQUENCE if not exists order_payment_seq
INCREMENT 1
START 1
MINVALUE 1
MAXVALUE 9223372036854775807
CACHE 1;

CREATE TABLE customer_order (
order_id bigint NOT NULL,
order_description varchar(256) NOT NULL,
order_date timestamp(0) without time zone NOT NULL,
CONSTRAINT order_pkey PRIMARY KEY (order_id)
);

CREATE TABLE order_item (
order_id bigint NOT NULL references customer_order (order_id),
order_item_id bigint NOT NULL DEFAULT nextval('order_item_seq'),
item_description varchar(2048) NOT NULL,
quantity integer NOT NULL,
price numeric(12,2) NOT NULL,
CONSTRAINT order_item_pkey PRIMARY KEY (order_id,order_item_id)
);

CREATE TABLE order_payment (
order_id bigint NOT NULL references customer_order (order_id),
payment_id bigint NOT NULL DEFAULT nextval('order_payment_seq'),
amount numeric(12,2) NOT NULL ,
payment_date timestamp(0) without time zone,
CONSTRAINT order_payment_pkey PRIMARY KEY (order_id,payment_id)
);

