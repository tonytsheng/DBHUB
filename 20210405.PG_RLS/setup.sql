### restrict column access
#login as postgres
create user admin with password 'Pass';
create table employee ( empno int, ename text, address text, salary int, account_number text );
insert into employee values (1, 'john', '2 down str',  20000, 'HDFC-22001' );
insert into employee values (2, 'clark', '132 south avn',  80000, 'HDFC-23029' );
insert into employee values (3, 'soojie', 'Down st 17th',  60000, 'ICICI-19022' );
select * from employee;

revoke SELECT on employee from admin ;
create view emp_info as select empno, ename, address from employee;
grant SELECT on emp_info TO admin;

# connect as admin
\c pg1001 admin
select * from employee;
select * from emp_info;
select * from emp_info where salary > 200;

### column level encryption
# connect as admin
grant select (empno, ename, address,account_number) on employee to admin;
CREATE EXTENSION pgcrypto;
TRUNCATE TABLE employee;
insert into employee values (1, 'john', '2 down str',  20000, pgp_sym_encrypt('HDFC-22001','emp_sec_key'));
insert into employee values (2, 'clark', '132 south avn',  80000, pgp_sym_encrypt('HDFC-23029', 'emp_sec_key'));
insert into employee values (3, 'soojie', 'Down st 17th',  60000, pgp_sym_encrypt('ICICI-19022','emp_sec_key'));
select * from employee;
revoke SELECT on employee from admin;
grant select (empno, ename, address,account_number) on employee to admin;

\c pg1001 admin
# return encrypted value
select empno, ename, address,account_number from employee;

# return decrypted value - using the key
select empno, ename, address,pgp_sym_decrypt(account_number::bytea,'emp_sec_key') from employee;

# cannot return decrypted value - bad key
select empno, ename, address,pgp_sym_decrypt(account_number::bytea,'random_key') from employee;


## row level security
\c pg1001 postgres
create table employee ( empno int, ename text, address text, salary int, account_number text );
insert into employee values (1, 'john', '2 down str',  20000, 'HDFC-22001' );
insert into employee values (2, 'clark', '132 south avn',  80000, 'HDFC-23029' );
insert into employee values (3, 'soojie', 'Down st 17th',  60000, 'ICICI-19022' );
select * from employee;

create user john with password 'Pass';
create user clark with password 'Pass';
create user soojie with password 'Pass';
grant select on employee to john;
grant select on employee to clark;
grant select on employee to soojie;

create policy emp_rls_policy on employee for all to public using (ename=current_user);
alter table employee enable row level security;

\c pg1001 john
john@pg1001=> select current_user;
 current_user
--------------
 john
(1 row)

john@pg1001=> select * from employee;
 empno | ename |  address   | salary | account_number
-------+-------+------------+--------+----------------
     1 | john  | 2 down str |  20000 | HDFC-22001
(1 row)

DROP POLICY emp_rls_policy ON employee;
ALTER TABLE employee DISABLE ROW LEVEL SECURITY;

## combine row and column level
revoke SELECT on employee from john;
grant select (empno, ename, address) on employee to john;
\c postgres john
select empno, ename, address from employee;

## using session variables
postgres=# grant  SELECT on employee to PUBLIC;
postgres=# DROP POLICY emp_rls_policy ON employee;
postgres=# CREATE POLICY emp_rls_policy ON employee FOR all TO public USING (ename=current_setting('rls.ename'));
postgres=# ALTER TABLE employee ENABLE ROW LEVEL SECURITY;
postgres=# \c postgres john
postgres=> set rls.ename = 'smith';
postgres=> select * from employee;
 empno | ename |   address   | salary | account_number
-------+-------+-------------+--------+----------------
     4 | smith | ash dwn str |  85000 | HDFC-22121
(1 row)
postgres=> set rls.ename = 'wrong';
postgres=> select * from employee;
 empno | ename | address | salary | account_number
-------+-------+---------+--------+----------------
(0 rows)

-- 3 levels of users
root -- see everything
admin -- see admin data
analyst -- lowest

create table important (id int, name text, root_info text, admin_info text, analyst_info text);
insert into important values (1, 'john', 'root','admin','analyst');
insert into important values (2, 'clark', 'root','admin','analyst');
insert into important values (3, 'tom', 'root','admin','analyst');

create table employee ( empno int, ename text, address text, salary int, account_number text );
insert into employee values (1, 'john', '2 down str',  20000, 'HDFC-22001' );
insert into employee values (2, 'clark', '132 south avn',  80000, 'HDFC-23029' );
insert into employee values (3, 'soojie', 'Down st 17th',  60000, 'ICICI-19022' );
select * from employee;

create user john with password 'Pass';
create user clark with password 'Pass';
create user soojie with password 'Pass';
grant select on employee to john;
grant select on employee to clark;
grant select on employee to soojie;

create policy emp_rls_policy on employee for all to public using (ename=current_user);
alter table employee enable row level security;

\c pg1001 john
john@pg1001=> select current_user;
 current_user
--------------

CREATE VIEW users_view
WITH (security_barrier = true, check_option = local) AS
SELECT /* accessible to everyone */
       username,
       /* accessible only to certain groups */
       CASE WHEN pg_has_role('x', 'USAGE') OR pg_has_role('y', 'USAGE')
            THEN level2_col
            ELSE NULL
       END AS level2_col,
       /* accessible only to admins and owner */
       CASE WHEN username = current_user OR pg_has_role('admin', 'USAGE')
            THEN level3_col
            ELSE NULL
       END AS level3_col
FROM users;



