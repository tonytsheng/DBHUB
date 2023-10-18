CREATE TABLE inventory.employee
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

CREATE UNIQUE INDEX emp_emp_id_pk ON inventory.employee (employee_id) ;
alter table inventory.employee add constraint employee_pk primary key (employee_id);


create table inventory.txtype
( txtype text)
;


