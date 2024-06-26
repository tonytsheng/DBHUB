CREATE SERVER pgactive_server_endpoint3
    FOREIGN DATA WRAPPER pgactive_fdw
    OPTIONS (host 'pg5003.cyt4dgtj55oy.us-east-2.rds.amazonaws.com', dbname 'app');
CREATE USER MAPPING FOR postgres
    SERVER pgactive_server_endpoint3
    OPTIONS (user 'postgres', password 'Pass');

CREATE SERVER pgactive_server_endpoint2
    FOREIGN DATA WRAPPER pgactive_fdw
    OPTIONS (host 'pg5002.cyt4dgtj55oy.us-east-2.rds.amazonaws.com', dbname 'app');
CREATE USER MAPPING FOR postgres
    SERVER pgactive_server_endpoint2
    OPTIONS (user 'postgres', password 'Pass');

CREATE SERVER pgactive_server_endpoint1
    FOREIGN DATA WRAPPER pgactive_fdw
    OPTIONS (host 'pg5001.cyt4dgtj55oy.us-east-2.rds.amazonaws.com', dbname 'app');
CREATE USER MAPPING FOR postgres
    SERVER pgactive_server_endpoint1
    OPTIONS (user 'postgres', password 'Pass');

SELECT pgactive.pgactive_join_group(node_name := 'endpoint3-app'
  , node_dsn := 'host=pg5003.cyt4dgtj55oy.us-east-2.rds.amazonaws.com dbname=app port=5432 user=postgres password=Pass'
  , join_using_dsn := 'host=pg5001.cyt4dgtj55oy.us-east-2.rds.amazonaws.com dbname=app port=5432 user=postgres password=Pass');

SELECT pgactive.pgactive_wait_for_node_ready();

