CREATE SERVER pgactive_server_endpoint1
    FOREIGN DATA WRAPPER pgactive_fdw
    OPTIONS (host 'pg1001.cyt4dgtj55oy.us-east-2.rds.amazonaws.com', dbname 'app');
CREATE USER MAPPING FOR postgres
    SERVER pgactive_server_endpoint1
    OPTIONS (user 'postgres', password 'Pass1234');

CREATE SERVER pgactive_server_endpoint2
    FOREIGN DATA WRAPPER pgactive_fdw
    OPTIONS (host 'pg1002.cyt4dgtj55oy.us-east-2.rds.amazonaws.com', dbname 'app');
CREATE USER MAPPING FOR postgres
    SERVER pgactive_server_endpoint2
    OPTIONS (user 'postgres', password 'Pass1234');

CREATE SERVER pgactive_server_endpoint3
    FOREIGN DATA WRAPPER pgactive_fdw
    OPTIONS (host 'pg1003.cyt4dgtj55oy.us-east-2.rds.amazonaws.com', dbname 'app');
CREATE USER MAPPING FOR postgres
    SERVER pgactive_server_endpoint3
    OPTIONS (user 'postgres', password 'Pass1234');

SELECT pgactive.pgactive_create_group
  (node_name := 'endpoint1-app'
  ,node_dsn := 'host=pg1001.cyt4dgtj55oy.us-east-2.rds.amazonaws.com dbname=app port=5432 user=postgres password=Pass1234')
;
SELECT pgactive.pgactive_wait_for_node_ready();


