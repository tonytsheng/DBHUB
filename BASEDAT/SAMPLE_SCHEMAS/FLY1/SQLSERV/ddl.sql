use fly1
go
drop table airline
go
drop table airport
go
drop table employee
go
drop table reservation
go
create table airline 
    ( id numeric not null identity
    , airline_name varchar(90) not null 
    , ind varchar(30)
    , abbreviation varchar(3)
    , formal_name varchar(90)
    , origin_country varchar(40)
    , ind2 varchar(40))
go

create unique index airline_pkidx on airline (id, airline_name)
go
alter table airline add constraint airline_pk primary key (id, airline_name)
go
grant select,insert,update,delete on airline to fly1
go

create table airport 
    (airport_code varchar(4) not null
    , airport_name varchar(90) not null
    , airport_num numeric
    , iata_code varchar(3))
go
create unique index airport_pkidx on airport (airport_code, airport_name)
go
alter table airport add constraint airport_pk primary key (airport_code, airport_name)
go
grant select,insert,update,delete on airport to fly1
go

create table reservation 
    ( id numeric identity not null
    , lname varchar(30) not null
    , fname varchar(30) not null
    , seatno varchar(10) not null
    , flightno varchar(10) not null
    , dep varchar(3) not null
    , arr varchar(3) not null
    , reservedate date not null)
go
create unique index reservation_pkidx on reservation (id, lname, fname, seatno, flightno, dep, arr, reservedate)
go
alter table reservation add constraint reservation_pk primary key (id, lname, fname, seatno, flightno, dep, arr, reservedate)
go
grant select,insert,update,delete on reservation to fly1
go

CREATE TABLE employee
    ( employee_id    numeric not null 
    , first_name     VARCHAR(20) not null
    , last_name      VARCHAR(25) not null
    , email          VARCHAR(25) not null
    , phone_number   VARCHAR(20)
    , hire_date      DATE
    , job_id         VARCHAR(10)
    , salary         numeric
    , commission_pct numeric
    , manager_id     numeric
    , department_id  numeric
    ) ;

CREATE UNIQUE INDEX emp_emp_id_pk ON employee (employee_id) 
go
alter table employee add constraint employee_pk primary key (employee_id)
go
grant select,insert,update,delete on employee to fly1
go
