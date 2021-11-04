drop table fly.airline;
drop table fly.employee;
drop table fly.airport;
drop table fly.reservation;
drop sequence fly.reservation_seq;

create table fly.airline (
id int, 
name varchar(30), 
ind varchar(1), 
abbreviation varchar(3), 
formal_name varchar(30), 
origin_country varchar(30), 
ind2 varchar(1));

create unique index airline_pkidx on fly.airline (id, name);
alter table fly.airline add constraint airline_pk primary key (id, name);

create table fly.airport (airport_code varchar(4), airport_name varchar(60), airport_c numeric, iata_code varchar(3));
create unique index airport_pkidx on fly.airport (airport_code, airport_name);
alter table fly.airport add constraint airport_pk primary key (airport_code, airport_name);

create table fly.reservation (
id int generated always as identity,
lname varchar(30),
fname varchar(30),
seatno varchar(10),
flightno varchar(10),
dep varchar(3),
arr varchar(3),
reservedate date);

create unique index reservation_pkidx on fly.reservation (id, lname, fname, seatno, flightno, dep, arr, reservedate);
alter table fly.reservation add constraint reservation_pk primary key (id, lname, fname, seatno, flightno, dep, arr, reservedate);

CREATE SEQUENCE fly.reservation_seq
    INCREMENT BY 1
    START WITH 10
    MINVALUE 10
    MAXVALUE 100000
    CYCLE
    CACHE 10;

CREATE TABLE fly.employee
    ( employee_id    int
    , first_name     VARCHAR(20)
    , last_name      VARCHAR(25)
    , email          VARCHAR(25)
    , phone_number   VARCHAR(20)
    , hire_date      DATE
    , job_id         VARCHAR(10)
    , salary         int
    , commission_pct int
    , manager_id     int
    , department_id  int
    ) ;

CREATE UNIQUE INDEX emp_emp_id_pk ON fly.employee (employee_id) ;
alter table fly.employee add constraint employee_pk primary key (employee_id);
\q