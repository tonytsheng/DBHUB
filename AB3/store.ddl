drop table customer_orders.stores;
CREATE TABLE customer_orders.stores(
    store_id BIGINT NOT NULL,
    store_name CHARACTER VARYING(255) NOT NULL,
    web_address CHARACTER VARYING(100),
    physical_address CHARACTER VARYING(512),
    latitude numeric,
    longitude numeric,
    logo BYTEA,
    logo_mime_type CHARACTER VARYING(512),
    logo_filename CHARACTER VARYING(512),
    logo_charset CHARACTER VARYING(512),
    logo_last_updated TIMESTAMP(0) WITHOUT TIME ZONE
)
        WITH (
        OIDS=FALSE
        );

ALTER TABLE customer_orders.stores
ADD CONSTRAINT stores_pk PRIMARY KEY (store_id);
ALTER TABLE customer_orders.stores
ADD CONSTRAINT store_at_least_one_address_c CHECK (web_address IS NOT NULL OR physical_address IS NOT NULL);
ALTER TABLE customer_orders.stores
ADD CONSTRAINT store_name_u UNIQUE (store_name);
