drop table airline;
drop table employee;
drop table airport;
drop table reservation;
drop sequence reservation_seq;

create table airline (
id number, 
name varchar(30), 
ind varchar(1), 
abbreviation varchar(3), 
formal_name varchar(30), 
origin_country varchar(30), 
ind2 varchar(1));

create unique index airline_pkidx on airline (id, name);
alter table airline add constraint airline_pk primary key (id, name);

create table airport (airport_code varchar(4), airport_name varchar(60), airport_c numeric, iata_code varchar(3));
create unique index airport_pkidx on airport (airport_code, airport_name);
alter table airport add constraint airport_pk primary key (airport_code, airport_name);

create table reservation (
id number,
lname varchar(30),
fname varchar(30),
seatno varchar(10),
flightno varchar(10),
dep varchar(3),
arr varchar(3),
reservedate date);

create unique index reservation_pkidx on reservation (id, lname, fname, seatno, flightno, dep, arr, reservedate);
alter table reservation add constraint reservation_pk primary key (id, lname, fname, seatno, flightno, dep, arr, reservedate);

CREATE SEQUENCE reservation_seq
    INCREMENT BY 1
    START WITH 10
    MINVALUE 10
    MAXVALUE 100000
    CYCLE
    CACHE 10;

CREATE TABLE employee
    ( employee_id    NUMBER(6)
    , first_name     VARCHAR2(20)
    , last_name      VARCHAR2(25)
         CONSTRAINT     emp_last_name_nn  NOT NULL
    , email          VARCHAR2(25)
        CONSTRAINT     emp_email_nn  NOT NULL
    , phone_number   VARCHAR2(20)
    , hire_date      DATE
        CONSTRAINT     emp_hire_date_nn  NOT NULL
    , job_id         VARCHAR2(10)
        CONSTRAINT     emp_job_nn  NOT NULL
    , salary         NUMBER(8,2)
    , commission_pct NUMBER(2,2)
    , manager_id     NUMBER(6)
    , department_id  NUMBER(4)
    , CONSTRAINT     emp_salary_min
                     CHECK (salary > 0)
    , CONSTRAINT     emp_email_uk
                     UNIQUE (email)
    ) ;

CREATE UNIQUE INDEX emp_emp_id_pk ON employee (employee_id) ;
alter table employee add constraint employee_pk primary key (employee_id);

