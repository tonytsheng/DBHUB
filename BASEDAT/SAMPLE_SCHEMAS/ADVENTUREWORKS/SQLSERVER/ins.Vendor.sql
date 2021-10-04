use adventureworks
go
set quoted_identifier on
go
delete from purchasing.vendor
go
insert into Purchasing.Vendor values ((select top 1 businessentityid from person.businessentity order by newid())
  ,'AUSTRALI0001','Australia Bike Retailer',1,1,1,NULL,'2011-12-23 00:00:00')
go
insert into Purchasing.Vendor values ((select top 1 businessentityid from person.businessentity order by newid())
  ,'ALLENSON0001','Allenson Cycles',2,1,1,NULL,'2011-04-25 00:00:00')
go
insert into Purchasing.Vendor values ((select top 1 businessentityid from person.businessentity order by newid())
  ,'ADVANCED0001','Advanced Bicycles',1,1,1,NULL,'2011-04-25 00:00:00')
go
insert into Purchasing.Vendor values ((select top 1 businessentityid from person.businessentity order by newid())
  ,'TRIKES0001','Trikes, Inc.',2,1,1,NULL,'2012-02-03 00:00:00')
go
insert into Purchasing.Vendor values ((select top 1 businessentityid from person.businessentity order by newid())
  ,'MORGANB0001','Morgan Bike Accessories',1,1,1,NULL,'2012-02-02 00:00:00')
go
insert into Purchasing.Vendor values ((select top 1 businessentityid from person.businessentity order by newid())
  ,'CYCLING0001','Cycling Master',1,1,1,NULL,'2011-12-24 00:00:00')
go
insert into Purchasing.Vendor values ((select top 1 businessentityid from person.businessentity order by newid())
  ,'CHICAGO0002','Chicago Rent-All',2,1,1,NULL,'2011-12-24 00:00:00')
go
insert into Purchasing.Vendor values ((select top 1 businessentityid from person.businessentity order by newid())
  ,'GREENWOO0001','Greenwood Athletic Company',1,1,1,NULL,'2012-01-25 00:00:00')
go
insert into Purchasing.Vendor values ((select top 1 businessentityid from person.businessentity order by newid())
  ,'COMPETE0001','Compete Enterprises, Inc',1,1,1,NULL,'2011-12-24 00:00:00')
go
insert into Purchasing.Vendor values ((select top 1 businessentityid from person.businessentity order by newid())
  ,'INTERNAT0001','International',1,1,1,NULL,'2012-01-25 00:00:00')
go
insert into Purchasing.Vendor values ((select top 1 businessentityid from person.businessentity order by newid())
  ,'LIGHTSP0001','Light Speed',1,1,1,NULL,'2011-12-23 00:00:00')
go
insert into Purchasing.Vendor values ((select top 1 businessentityid from person.businessentity order by newid())
  ,'TRAINING0001','Training Systems',1,1,1,NULL,'2012-02-03 00:00:00')
go
insert into Purchasing.Vendor values ((select top 1 businessentityid from person.businessentity order by newid())
  ,'GARDNER0001','Gardner Touring Cycles',1,0,0,NULL,'2012-01-25 00:00:00')
go
insert into Purchasing.Vendor values ((select top 1 businessentityid from person.businessentity order by newid())
  ,'INTERNAT0004','International Trek Center',1,1,1,NULL,'2011-12-24 00:00:00')
go
insert into Purchasing.Vendor values ((select top 1 businessentityid from person.businessentity order by newid())
  ,'G&KBI0001','G & K Bicycle Corp.',1,1,1,NULL,'2011-12-24 00:00:00')
go
insert into Purchasing.Vendor values ((select top 1 businessentityid from person.businessentity order by newid())
  ,'FIRSTNA0001','First National Sport Co.',1,1,1,NULL,'2012-01-25 00:00:00')
go
insert into Purchasing.Vendor values ((select top 1 businessentityid from person.businessentity order by newid())
  ,'RECREATI0001','Recreation Place',4,1,1,NULL,'2012-02-02 00:00:00')
go
insert into Purchasing.Vendor values ((select top 1 businessentityid from person.businessentity order by newid())
  ,'INTERNAT0002','International Bicycles',1,1,1,NULL,'2012-01-25 00:00:00')
go
insert into Purchasing.Vendor values ((select top 1 businessentityid from person.businessentity order by newid())
  ,'IMAGEMA0001','Image Makers Bike Center',1,1,1,NULL,'2012-02-03 00:00:00')
go
insert into Purchasing.Vendor values ((select top 1 businessentityid from person.businessentity order by newid())
  ,'COMFORT0001','Comfort Road Bicycles,1,1,1,NULL,'2011-12-24 00:00:00')
go
