use fly1;
drop table airline;
drop table airport;
drop table reservation;
drop table employee;

create table airline (
id numeric, 
airline_name varchar(30), 
ind varchar(1), 
abbreviation varchar(30), 
formal_name varchar(30), 
origin_country varchar(30), 
ind2 varchar(1));

create unique index airline_pkidx on airline (id, airline_name);
alter table airline add constraint airline_pk primary key (id, airline_name);

create table airport (airport_code varchar(4), airport_name varchar(60), airport_c numeric, iata_code varchar(3));
create unique index airport_pkidx on airport (airport_code, airport_name);
alter table airport add constraint airport_pk primary key (airport_code, airport_name);

create table reservation (
reserve_id integer NOT NULL AUTO_INCREMENT ,
lname varchar(30),
fname varchar(30),
seatno varchar(10),
flightno varchar(10),
dep varchar(3),
arr varchar(3),
reservedate date,
PRIMARY KEY (reserve_id)
);

create unique index reservation_pkidx on reservation (reserve_id, lname, fname, seatno, flightno, dep, arr, reservedate);
alter table reservation add constraint reservation_pk primary key (reserve_id, lname, fname, seatno, flightno, dep, arr, reservedate);

CREATE TABLE employee
    ( employee_id    numeric
    , first_name     VARCHAR(25)
    , last_name      VARCHAR(25)
    , email_adress   VARCHAR(25)
    , phone_number   VARCHAR(20)
    , hire_date      DATE
    , job_id         VARCHAR(10)
    , salary         numeric
    , commission_pct numeric
    , manager_id     numeric
    , department_id  numeric
    ) ;

CREATE UNIQUE INDEX emp_emp_id_pk ON employee (employee_id) ;
alter table employee add constraint employee_pk primary key (employee_id);

