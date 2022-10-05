create login fly1 with password ='fly1';
go
create database fly1;
go
use fly1;
go
create user fly1 for login fly1
go
grant alter on schema::dbo to fly1
go
grant create table to fly1
go
grant create sequence to fly1
go
grant create index to fly1
go


