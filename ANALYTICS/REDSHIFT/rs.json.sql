create table customers (id smallint, details super);

insert into customers values (4, JSON_PARSE('{"name":"John", "age":31, "city":"New York"}'));
-- JSON_PARSE in all upper
dev=# select id, details.name from customers;
 id |  name
----+--------
  1 |
  2 | "John"
  3 | "John"
  3 | "John"
  4 | "John"
(5 rows)

dev=# select id, details.city from customers;
 id |    city
----+------------
  1 |
  2 |
  3 |
  3 | "New York"
  4 | "New York"
(5 rows)

insert into customers values (11, JSON_PARSE('{"CreationDateTime":1721011165891550,"Keys":{"flight_date":{"S":"2024-01-19 05:01:49"},"flight_number":{"S":"AC31"}}}' ));

dev=# select details.name from customers;
  name
--------

 "John"
 "John"
 "John"
 "John"


(7 rows)

dev=# select details.CreationDateTime from customers;
 creationdatetime
------------------







(7 rows)

dev=# select details.Keys.flight_date from customers;
 flight_date
-------------







(7 rows)

insert into customers values (12, JSON_PARSE('{"CreationDateTime":1721011165891550}' ));

insert into customers values (13, JSON_PARSE('{"CreationDateTime":"1721011165891550"}' ));
insert into customers values (14, JSON_PARSE('{"create_date":"2024-09-01"}' ));

dev=# select * from customers;
 id |                                                        details
----+-----------------------------------------------------------------------------------------------------------------------
  1 | "tts"
  2 | {"name":"John"}
  3 | {"name":"John","age":31}
  3 | {"name":"John","age":31,"city":"New York"}
  4 | {"name":"John","age":31,"city":"New York"}
  4 | {"ApproximateCreationDateTime":1721011165891550,"flight_date":{"S":"2024-01-23 04:01:53"}}
 11 | {"CreationDateTime":1721011165891550,"Keys":{"flight_date":{"S":"2024-01-19 05:01:49"},"flight_number":{"S":"AC31"}}}
 12 | {"CreationDateTime":1721011165891550}
 13 | {"CreationDateTime":"1721011165891550"}
 14 | {"create_date":"2024-09-01"}
(10 rows)

dev=# select details.create_date from customers;
 create_date
--------------









 "2024-09-01"
(10 rows)

dev=# select details.CREATE_DATE from customers;
 create_date
--------------









 "2024-09-01"
(10 rows)



drop table customers;
create table customers (id int generated always as identity, details super);

insert into customers (details) values (JSON_PARSE('{"created_date":1721011165891550,"Keys":{"flight_date":{"S":"2024-01-19 05:01:49"},"flight_number":{"S":"AC31"}}}' ));
insert into customers (details) values (JSON_PARSE('{"created_date":"1721011165891550","Keys":{"flight_date":{"S":"2024-01-19 05:01:49"},"flight_number":{"S":"AC31"}}}' ));
insert into customers (details) values (JSON_PARSE('{"created_date":"2024-09-01","Keys":{"flight_date":{"S":"2024-01-19 05:01:49"},"flight_number":{"S":"AC31"}}}' ));
insert into customers (details) values (JSON_PARSE('{"created_date":1721011165891550,"Keys":{"flight_date":"2024-01-19 05:01:49","flight_number":"AC31"}}' ));
insert into customers (details) values (JSON_PARSE('{"created_date":1721011165891550,"flight_date":"2024-01-19 05:01:49","flight_number":"AC31"}' ));
