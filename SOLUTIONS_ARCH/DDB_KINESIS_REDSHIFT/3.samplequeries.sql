SET enable_case_sensitive_identifier to TRUE;
refresh materialized view demo_stream_vw;

SELECT
  EXTRACT( HOUR FROM approximate_arrival_timestamp) AS hour
  , payload."dynamodb"."NewImage"."arr"."S"::varchar as arrival
  , COUNT(*) AS count
FROM
  demo_stream_vw
GROUP BY
  hour
  , arrival
ORDER BY
  hour
  , arrival;


SELECT
  EXTRACT( DAY FROM approximate_arrival_timestamp) AS day
  , payload."dynamodb"."NewImage"."arr"."S"::varchar as arrival
  , COUNT(*) AS count
FROM
  demo_stream_vw
GROUP BY
  day
  , arrival
ORDER BY
  day
  , arrival;



SELECT
  EXTRACT( DAY FROM approximate_arrival_timestamp) AS day_of_month
  , payload."dynamodb"."NewImage"."status"."S"::varchar as status
  , COUNT(*) AS count
FROM
  demo_stream_vw
GROUP BY
  day_of_month
  , status
ORDER BY
  count desc,
  status
  , day_of_month;
