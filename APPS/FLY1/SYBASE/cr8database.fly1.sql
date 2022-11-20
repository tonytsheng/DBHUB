drop database fly1
go
disk init name="fly1_data", physname="/opt/sap/data/fly1_data.dat" ,size="5120"
go
disk init name="fly1_log", physname="/opt/sap/data/fly1_log.dat", size="5120"
go
create database fly1 on fly1_data log on fly1_log 
go
sp_addlogin fly1, 'fly1fly1'
go
use fly1
go
sp_adduser fly1
go
grant create table to fly1
go

