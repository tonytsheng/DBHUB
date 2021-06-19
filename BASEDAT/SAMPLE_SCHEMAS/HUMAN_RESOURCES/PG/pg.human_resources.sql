
CREATE TABLE human_resources.regions
    ( region_id      numeric 
       CONSTRAINT  region_id_nn NOT NULL 
    , region_name    VARCHAR(25) 
    );


CREATE TABLE human_resources.countries 
    ( country_id      CHAR(2) 
       CONSTRAINT  country_id_nn NOT NULL 
    , country_name    VARCHAR(40) 
    , region_id       numeric 
    ) ;


CREATE TABLE human_resources.locations
    ( location_id    numeric(4)
    , street_address VARCHAR(40)
    , postal_code    VARCHAR(12)
    , city       VARCHAR(30)
	CONSTRAINT     loc_city_nn  NOT NULL
    , state_province VARCHAR(25)
    , country_id     CHAR(2)
    ) ;

CREATE TABLE human_resources.departments
    ( department_id    numeric(4)
    , department_name  VARCHAR(30)
	CONSTRAINT  dept_name_nn  NOT NULL
    , manager_id       numeric(6)
    , location_id      numeric(4)
    ) ;

CREATE TABLE human_resources.jobs
    ( job_id         VARCHAR(10)
    , job_title      VARCHAR(35)
	CONSTRAINT     job_title_nn  NOT NULL
    , min_salary     numeric(6)
    , max_salary     numeric(6)
    ) ;

CREATE TABLE human_resources.employees
    ( employee_id    numeric(6)
    , first_name     VARCHAR(20)
    , last_name      VARCHAR(25)
	 CONSTRAINT     emp_last_name_nn  NOT NULL
    , email          VARCHAR(25)
	CONSTRAINT     emp_email_nn  NOT NULL
    , phone_number   VARCHAR(20)
    , hire_date      DATE
	CONSTRAINT     emp_hire_date_nn  NOT NULL
    , job_id         VARCHAR(10)
	CONSTRAINT     emp_job_nn  NOT NULL
    , salary         numeric(8,2)
    , commission_pct numeric(2,2)
    , manager_id     numeric(6)
    , department_id  numeric(4)
    , CONSTRAINT     emp_salary_min
                     CHECK (salary > 0) 
    , CONSTRAINT     emp_email_uk
                     UNIQUE (email)
    ) ;


CREATE TABLE human_resources.job_history
    ( employee_id   numeric(6)
	 CONSTRAINT    jhist_employee_nn  NOT NULL
    , start_date    DATE
	CONSTRAINT    jhist_start_date_nn  NOT NULL
    , end_date      DATE
	CONSTRAINT    jhist_end_date_nn  NOT NULL
    , job_id        VARCHAR(10)
	CONSTRAINT    jhist_job_nn  NOT NULL
    , department_id numeric(4)
    , CONSTRAINT    jhist_date_interval
                    CHECK (end_date > start_date)
    ) ;

CREATE OR REPLACE VIEW emp_details_view
  (employee_id,
   job_id,
   manager_id,
   department_id,
   location_id,
   country_id,
   first_name,
   last_name,
   salary,
   commission_pct,
   department_name,
   job_title,
   city,
   state_province,
   country_name,
   region_name)
AS SELECT
  e.employee_id, 
  e.job_id, 
  e.manager_id, 
  e.department_id,
  d.location_id,
  l.country_id,
  e.first_name,
  e.last_name,
  e.salary,
  e.commission_pct,
  d.department_name,
  j.job_title,
  l.city,
  l.state_province,
  c.country_name,
  r.region_name
FROM
  human_resources.employees e,
  human_resources.departments d,
  human_resources.jobs j,
  human_resources.locations l,
  human_resources.countries c,
  human_resources.regions r
WHERE e.department_id = d.department_id
  AND d.location_id = l.location_id
  AND l.country_id = c.country_id
  AND c.region_id = r.region_id
  AND j.job_id = e.job_id ;

