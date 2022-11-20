use Adventureworks
go
set quoted_identifier on
go
delete from Production.Product
go

insert into Production.Product values ('Adjustable Race','AR-5381',0,0,NULL,1000,750,0,0,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,getdate(),NULL,NULL,newid(),getdate())
go
insert into Production.Product values ('Bearing Ball','BA-8327',0,0,NULL,1000,750,0,0,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,getdate(),NULL,NULL,newid(),getdate())
go
insert into Production.Product values ('BB Ball Bearing','BE-2349',1,0,NULL,800,600,0,0,NULL,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,getdate(),NULL,NULL,newid(),getdate())
go
insert into Production.Product values ('Headset Ball Bearings','BE-2908',0,0,NULL,800,600,0,0,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,getdate(),NULL,NULL,newid(),getdate())
go
insert into Production.Product values ('Blade','BL-2036',1,0,NULL,800,600,0,0,NULL,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,getdate(),NULL,NULL,newid(),getdate())
go
insert into Production.Product values ('LL Crankarm','CA-5965',0,0,'Black',500,375,0,0,NULL,NULL,NULL,NULL,0,NULL,'L' ,NULL,NULL,NULL,getdate(),NULL,NULL,newid(),getdate())
go
insert into Production.Product values ('ML Crankarm','CA-6738',0,0,'Black',500,375,0,0,NULL,NULL,NULL,NULL,0,NULL,'M' ,NULL,NULL,NULL,getdate(),NULL,NULL,newid(),getdate())
go
insert into Production.Product values ('HL Crankarm','CA-7457',0,0,'Black',500,375,0,0,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,getdate(),NULL,NULL,newid(),getdate())
go
insert into Production.Product values ('Chainring B','CB-2903',0,0,'Silve',100,750,0,0,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,getdate(),NULL,NULL,newid(),getdate())
go
insert into Production.Product values ('Chainring Nut','CN-6137',0,0,'Silver',1000,750,0,0,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,getdate(),NULL,NULL,newid(),getdate())
go
insert into Production.Product values ('Chainring','CR-7833',0,0,'Black',1000,750,0,0,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,getdate(),NULL,NULL,newid(),getdate())
go
insert into Production.Product values ('Crown Race','CR-9981',0,0,NULL,1000,750,0,0,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,getdate(),NULL,NULL,newid(),getdate())
go
insert into Production.Product values ('Chain Stays','CS-2812',1,0,NULL,1000,750,0,0,NULL,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,getdate(),NULL,NULL,newid(),getdate())
go
insert into Production.Product values ('Decal 1','DC-8732',0,0,NULL,1000,750,0,0,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,getdate(),NULL,NULL,newid(),getdate())
go
insert into Production.Product values ('Decal 2','DC-9824',0,0,NULL,1000,750,0,0,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,NULL,getdate(),NULL,NULL,newid(),getdate())
go
insert into Production.Product values ('Down Tube','DT-2377',1,0,NULL,800,600,0,0,NULL,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,getdate(),NULL,NULL,newid(),getdate())
go
insert into Production.Product values ('Mountain End Caps','EC-M092',1,0,NULL,1000,750,0,0,NULL,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,getdate(),NULL,NULL,newid(),getdate())
go
insert into Production.Product values ('Road End Caps','EC-R098',1,0,NULL,1000,750,0,0,NULL,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,getdate(),NULL,NULL,newid(),getdate())
go
insert into Production.Product values ('Touring End Caps','EC-T209',1,0,NULL,1000,750,0,0,NULL,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,getdate(),NULL,NULL,newid(),getdate())
go
commit
go

