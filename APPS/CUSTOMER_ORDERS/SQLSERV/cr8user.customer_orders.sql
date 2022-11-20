create login customer_orders with password ='customer_orders'
go
create database customer_orders
go
use customer_orders
go
create user customer_orders for login customer_orders
go

exec sp_addrolemember db_owner, customer_orders
go

