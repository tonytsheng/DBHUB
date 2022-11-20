exec msdb.dbo.rds_download_from_s3
@s3_arn_of_file='arn:aws:s3:::ttsheng-dbs3/sqlserver/Address.csv', 
@rds_file_path='D:\S3\seed_data\Address.csv', 
@overwrite_file=1;
go
exec msdb.dbo.rds_download_from_s3
@s3_arn_of_file='arn:aws:s3:::ttsheng-dbs3/sqlserver/AddressType.csv', 
@rds_file_path='D:\S3\seed_data\AddressType.csv', 
@overwrite_file=1;
go
exec msdb.dbo.rds_download_from_s3
@s3_arn_of_file='arn:aws:s3:::ttsheng-dbs3/sqlserver/AWBuildVersion.csv', 
@rds_file_path='D:\S3\seed_data\AWBuildVersion.csv', 
@overwrite_file=1;
go
exec msdb.dbo.rds_download_from_s3
@s3_arn_of_file='arn:aws:s3:::ttsheng-dbs3/sqlserver/BillOfMaterials.csv', 
@rds_file_path='D:\S3\seed_data\BillOfMaterials.csv', 
@overwrite_file=1;
go
exec msdb.dbo.rds_download_from_s3
@s3_arn_of_file='arn:aws:s3:::ttsheng-dbs3/sqlserver/BusinessEntityAddress.csv', 
@rds_file_path='D:\S3\seed_data\BusinessEntityAddress.csv', 
@overwrite_file=1;
go
exec msdb.dbo.rds_download_from_s3
@s3_arn_of_file='arn:aws:s3:::ttsheng-dbs3/sqlserver/BusinessEntityContact.csv', 
@rds_file_path='D:\S3\seed_data\BusinessEntityContact.csv', 
@overwrite_file=1;
go
exec msdb.dbo.rds_download_from_s3
@s3_arn_of_file='arn:aws:s3:::ttsheng-dbs3/sqlserver/BusinessEntity.csv', 
@rds_file_path='D:\S3\seed_data\BusinessEntity.csv', 
@overwrite_file=1;
go
exec msdb.dbo.rds_download_from_s3
@s3_arn_of_file='arn:aws:s3:::ttsheng-dbs3/sqlserver/ContactType.csv', 
@rds_file_path='D:\S3\seed_data\ContactType.csv', 
@overwrite_file=1;
go
exec msdb.dbo.rds_download_from_s3
@s3_arn_of_file='arn:aws:s3:::ttsheng-dbs3/sqlserver/CountryRegion.csv', 
@rds_file_path='D:\S3\seed_data\CountryRegion.csv', 
@overwrite_file=1;
go
exec msdb.dbo.rds_download_from_s3
@s3_arn_of_file='arn:aws:s3:::ttsheng-dbs3/sqlserver/CountryRegionCurrency.csv', 
@rds_file_path='D:\S3\seed_data\CountryRegionCurrency.csv', 
@overwrite_file=1;
go
exec msdb.dbo.rds_download_from_s3
@s3_arn_of_file='arn:aws:s3:::ttsheng-dbs3/sqlserver/CreditCard.csv', 
@rds_file_path='D:\S3\seed_data\CreditCard.csv', 
@overwrite_file=1;
go
exec msdb.dbo.rds_download_from_s3
@s3_arn_of_file='arn:aws:s3:::ttsheng-dbs3/sqlserver/Culture.csv', 
@rds_file_path='D:\S3\seed_data\Culture.csv', 
@overwrite_file=1;
go
exec msdb.dbo.rds_download_from_s3
@s3_arn_of_file='arn:aws:s3:::ttsheng-dbs3/sqlserver/Currency.csv', 
@rds_file_path='D:\S3\seed_data\Currency.csv', 
@overwrite_file=1;
go
exec msdb.dbo.rds_download_from_s3
@s3_arn_of_file='arn:aws:s3:::ttsheng-dbs3/sqlserver/CurrencyRate.csv', 
@rds_file_path='D:\S3\seed_data\CurrencyRate.csv', 
@overwrite_file=1;
go
exec msdb.dbo.rds_download_from_s3
@s3_arn_of_file='arn:aws:s3:::ttsheng-dbs3/sqlserver/Customer.csv', 
@rds_file_path='D:\S3\seed_data\Customer.csv', 
@overwrite_file=1;
go
exec msdb.dbo.rds_download_from_s3
@s3_arn_of_file='arn:aws:s3:::ttsheng-dbs3/sqlserver/Department.csv', 
@rds_file_path='D:\S3\seed_data\Department.csv', 
@overwrite_file=1;
go
exec msdb.dbo.rds_download_from_s3
@s3_arn_of_file='arn:aws:s3:::ttsheng-dbs3/sqlserver/Document.csv', 
@rds_file_path='D:\S3\seed_data\Document.csv', 
@overwrite_file=1;
go
exec msdb.dbo.rds_download_from_s3
@s3_arn_of_file='arn:aws:s3:::ttsheng-dbs3/sqlserver/EmailAddress.csv', 
@rds_file_path='D:\S3\seed_data\EmailAddress.csv', 
@overwrite_file=1;
go
exec msdb.dbo.rds_download_from_s3
@s3_arn_of_file='arn:aws:s3:::ttsheng-dbs3/sqlserver/Employee.csv', 
@rds_file_path='D:\S3\seed_data\Employee.csv', 
@overwrite_file=1;
go
exec msdb.dbo.rds_download_from_s3
@s3_arn_of_file='arn:aws:s3:::ttsheng-dbs3/sqlserver/EmployeeDepartmentHistory.csv', 
@rds_file_path='D:\S3\seed_data\EmployeeDepartmentHistory.csv', 
@overwrite_file=1;
go
exec msdb.dbo.rds_download_from_s3
@s3_arn_of_file='arn:aws:s3:::ttsheng-dbs3/sqlserver/EmployeePayHistory.csv', 
@rds_file_path='D:\S3\seed_data\EmployeePayHistory.csv', 
@overwrite_file=1;
go
exec msdb.dbo.rds_download_from_s3
@s3_arn_of_file='arn:aws:s3:::ttsheng-dbs3/sqlserver/Illustration.csv', 
@rds_file_path='D:\S3\seed_data\Illustration.csv', 
@overwrite_file=1;
go
exec msdb.dbo.rds_download_from_s3
@s3_arn_of_file='arn:aws:s3:::ttsheng-dbs3/sqlserver/JobCandidate.csv', 
@rds_file_path='D:\S3\seed_data\JobCandidate.csv', 
@overwrite_file=1;
go
exec msdb.dbo.rds_download_from_s3
@s3_arn_of_file='arn:aws:s3:::ttsheng-dbs3/sqlserver/JobCandidate_TOREMOVE.csv', 
@rds_file_path='D:\S3\seed_data\JobCandidate_TOREMOVE.csv', 
@overwrite_file=1;
go
exec msdb.dbo.rds_download_from_s3
@s3_arn_of_file='arn:aws:s3:::ttsheng-dbs3/sqlserver/Location.csv', 
@rds_file_path='D:\S3\seed_data\Location.csv', 
@overwrite_file=1;
go
exec msdb.dbo.rds_download_from_s3
@s3_arn_of_file='arn:aws:s3:::ttsheng-dbs3/sqlserver/Password.csv', 
@rds_file_path='D:\S3\seed_data\Password.csv', 
@overwrite_file=1;
go
exec msdb.dbo.rds_download_from_s3
@s3_arn_of_file='arn:aws:s3:::ttsheng-dbs3/sqlserver/PersonCreditCard.csv', 
@rds_file_path='D:\S3\seed_data\PersonCreditCard.csv', 
@overwrite_file=1;
go
exec msdb.dbo.rds_download_from_s3
@s3_arn_of_file='arn:aws:s3:::ttsheng-dbs3/sqlserver/Person.csv', 
@rds_file_path='D:\S3\seed_data\Person.csv', 
@overwrite_file=1;
go
exec msdb.dbo.rds_download_from_s3
@s3_arn_of_file='arn:aws:s3:::ttsheng-dbs3/sqlserver/PersonPhone.csv', 
@rds_file_path='D:\S3\seed_data\PersonPhone.csv', 
@overwrite_file=1;
go
exec msdb.dbo.rds_download_from_s3
@s3_arn_of_file='arn:aws:s3:::ttsheng-dbs3/sqlserver/PhoneNumberType.csv', 
@rds_file_path='D:\S3\seed_data\PhoneNumberType.csv', 
@overwrite_file=1;
go
exec msdb.dbo.rds_download_from_s3
@s3_arn_of_file='arn:aws:s3:::ttsheng-dbs3/sqlserver/ProductCategory.csv', 
@rds_file_path='D:\S3\seed_data\ProductCategory.csv', 
@overwrite_file=1;
go
exec msdb.dbo.rds_download_from_s3
@s3_arn_of_file='arn:aws:s3:::ttsheng-dbs3/sqlserver/ProductCostHistory.csv', 
@rds_file_path='D:\S3\seed_data\ProductCostHistory.csv', 
@overwrite_file=1;
go
exec msdb.dbo.rds_download_from_s3
@s3_arn_of_file='arn:aws:s3:::ttsheng-dbs3/sqlserver/Product.csv', 
@rds_file_path='D:\S3\seed_data\Product.csv', 
@overwrite_file=1;
go
exec msdb.dbo.rds_download_from_s3
@s3_arn_of_file='arn:aws:s3:::ttsheng-dbs3/sqlserver/ProductDescription.csv', 
@rds_file_path='D:\S3\seed_data\ProductDescription.csv', 
@overwrite_file=1;
go
exec msdb.dbo.rds_download_from_s3
@s3_arn_of_file='arn:aws:s3:::ttsheng-dbs3/sqlserver/ProductDocument.csv', 
@rds_file_path='D:\S3\seed_data\ProductDocument.csv', 
@overwrite_file=1;
go
exec msdb.dbo.rds_download_from_s3
@s3_arn_of_file='arn:aws:s3:::ttsheng-dbs3/sqlserver/ProductInventory.csv', 
@rds_file_path='D:\S3\seed_data\ProductInventory.csv', 
@overwrite_file=1;
go
exec msdb.dbo.rds_download_from_s3
@s3_arn_of_file='arn:aws:s3:::ttsheng-dbs3/sqlserver/ProductListPriceHistory.csv', 
@rds_file_path='D:\S3\seed_data\ProductListPriceHistory.csv', 
@overwrite_file=1;
go
exec msdb.dbo.rds_download_from_s3
@s3_arn_of_file='arn:aws:s3:::ttsheng-dbs3/sqlserver/ProductModel.csv', 
@rds_file_path='D:\S3\seed_data\ProductModel.csv', 
@overwrite_file=1;
go
exec msdb.dbo.rds_download_from_s3
@s3_arn_of_file='arn:aws:s3:::ttsheng-dbs3/sqlserver/ProductModelIllustration.csv', 
@rds_file_path='D:\S3\seed_data\ProductModelIllustration.csv', 
@overwrite_file=1;
go
exec msdb.dbo.rds_download_from_s3
@s3_arn_of_file='arn:aws:s3:::ttsheng-dbs3/sqlserver/ProductModelorg.csv', 
@rds_file_path='D:\S3\seed_data\ProductModelorg.csv', 
@overwrite_file=1;
go
exec msdb.dbo.rds_download_from_s3
@s3_arn_of_file='arn:aws:s3:::ttsheng-dbs3/sqlserver/ProductModelProductDescriptionCulture.csv', 
@rds_file_path='D:\S3\seed_data\ProductModelProductDescriptionCulture.csv', 
@overwrite_file=1;
go
exec msdb.dbo.rds_download_from_s3
@s3_arn_of_file='arn:aws:s3:::ttsheng-dbs3/sqlserver/ProductPhoto.csv', 
@rds_file_path='D:\S3\seed_data\ProductPhoto.csv', 
@overwrite_file=1;
go
exec msdb.dbo.rds_download_from_s3
@s3_arn_of_file='arn:aws:s3:::ttsheng-dbs3/sqlserver/ProductProductPhoto.csv', 
@rds_file_path='D:\S3\seed_data\ProductProductPhoto.csv', 
@overwrite_file=1;
go
exec msdb.dbo.rds_download_from_s3
@s3_arn_of_file='arn:aws:s3:::ttsheng-dbs3/sqlserver/ProductReview.csv', 
@rds_file_path='D:\S3\seed_data\ProductReview.csv', 
@overwrite_file=1;
go
exec msdb.dbo.rds_download_from_s3
@s3_arn_of_file='arn:aws:s3:::ttsheng-dbs3/sqlserver/ProductSubcategory.csv', 
@rds_file_path='D:\S3\seed_data\ProductSubcategory.csv', 
@overwrite_file=1;
go
exec msdb.dbo.rds_download_from_s3
@s3_arn_of_file='arn:aws:s3:::ttsheng-dbs3/sqlserver/ProductVendor.csv', 
@rds_file_path='D:\S3\seed_data\ProductVendor.csv', 
@overwrite_file=1;
go
exec msdb.dbo.rds_download_from_s3
@s3_arn_of_file='arn:aws:s3:::ttsheng-dbs3/sqlserver/PurchaseOrderDetail.csv', 
@rds_file_path='D:\S3\seed_data\PurchaseOrderDetail.csv', 
@overwrite_file=1;
go
exec msdb.dbo.rds_download_from_s3
@s3_arn_of_file='arn:aws:s3:::ttsheng-dbs3/sqlserver/PurchaseOrderHeader.csv', 
@rds_file_path='D:\S3\seed_data\PurchaseOrderHeader.csv', 
@overwrite_file=1;
go
exec msdb.dbo.rds_download_from_s3
@s3_arn_of_file='arn:aws:s3:::ttsheng-dbs3/sqlserver/SalesOrderDetail.csv', 
@rds_file_path='D:\S3\seed_data\SalesOrderDetail.csv', 
@overwrite_file=1;
go
exec msdb.dbo.rds_download_from_s3
@s3_arn_of_file='arn:aws:s3:::ttsheng-dbs3/sqlserver/SalesOrderHeader.csv', 
@rds_file_path='D:\S3\seed_data\SalesOrderHeader.csv', 
@overwrite_file=1;
go
exec msdb.dbo.rds_download_from_s3
@s3_arn_of_file='arn:aws:s3:::ttsheng-dbs3/sqlserver/SalesOrderHeaderSalesReason.csv', 
@rds_file_path='D:\S3\seed_data\SalesOrderHeaderSalesReason.csv', 
@overwrite_file=1;
go
exec msdb.dbo.rds_download_from_s3
@s3_arn_of_file='arn:aws:s3:::ttsheng-dbs3/sqlserver/SalesPerson.csv', 
@rds_file_path='D:\S3\seed_data\SalesPerson.csv', 
@overwrite_file=1;
go
exec msdb.dbo.rds_download_from_s3
@s3_arn_of_file='arn:aws:s3:::ttsheng-dbs3/sqlserver/SalesPersonQuotaHistory.csv', 
@rds_file_path='D:\S3\seed_data\SalesPersonQuotaHistory.csv', 
@overwrite_file=1;
go
exec msdb.dbo.rds_download_from_s3
@s3_arn_of_file='arn:aws:s3:::ttsheng-dbs3/sqlserver/SalesReason.csv', 
@rds_file_path='D:\S3\seed_data\SalesReason.csv', 
@overwrite_file=1;
go
exec msdb.dbo.rds_download_from_s3
@s3_arn_of_file='arn:aws:s3:::ttsheng-dbs3/sqlserver/SalesTaxRate.csv', 
@rds_file_path='D:\S3\seed_data\SalesTaxRate.csv', 
@overwrite_file=1;
go
exec msdb.dbo.rds_download_from_s3
@s3_arn_of_file='arn:aws:s3:::ttsheng-dbs3/sqlserver/SalesTerritory.csv', 
@rds_file_path='D:\S3\seed_data\SalesTerritory.csv', 
@overwrite_file=1;
go
exec msdb.dbo.rds_download_from_s3
@s3_arn_of_file='arn:aws:s3:::ttsheng-dbs3/sqlserver/SalesTerritoryHistory.csv', 
@rds_file_path='D:\S3\seed_data\SalesTerritoryHistory.csv', 
@overwrite_file=1;
go
exec msdb.dbo.rds_download_from_s3
@s3_arn_of_file='arn:aws:s3:::ttsheng-dbs3/sqlserver/ScrapReason.csv', 
@rds_file_path='D:\S3\seed_data\ScrapReason.csv', 
@overwrite_file=1;
go
exec msdb.dbo.rds_download_from_s3
@s3_arn_of_file='arn:aws:s3:::ttsheng-dbs3/sqlserver/Shift.csv', 
@rds_file_path='D:\S3\seed_data\Shift.csv', 
@overwrite_file=1;
go
exec msdb.dbo.rds_download_from_s3
@s3_arn_of_file='arn:aws:s3:::ttsheng-dbs3/sqlserver/ShipMethod.csv', 
@rds_file_path='D:\S3\seed_data\ShipMethod.csv', 
@overwrite_file=1;
go
exec msdb.dbo.rds_download_from_s3
@s3_arn_of_file='arn:aws:s3:::ttsheng-dbs3/sqlserver/ShoppingCartItem.csv', 
@rds_file_path='D:\S3\seed_data\ShoppingCartItem.csv', 
@overwrite_file=1;
go
exec msdb.dbo.rds_download_from_s3
@s3_arn_of_file='arn:aws:s3:::ttsheng-dbs3/sqlserver/SpecialOffer.csv', 
@rds_file_path='D:\S3\seed_data\SpecialOffer.csv', 
@overwrite_file=1;
go
exec msdb.dbo.rds_download_from_s3
@s3_arn_of_file='arn:aws:s3:::ttsheng-dbs3/sqlserver/SpecialOfferProduct.csv', 
@rds_file_path='D:\S3\seed_data\SpecialOfferProduct.csv', 
@overwrite_file=1;
go
exec msdb.dbo.rds_download_from_s3
@s3_arn_of_file='arn:aws:s3:::ttsheng-dbs3/sqlserver/StateProvince.csv', 
@rds_file_path='D:\S3\seed_data\StateProvince.csv', 
@overwrite_file=1;
go
exec msdb.dbo.rds_download_from_s3
@s3_arn_of_file='arn:aws:s3:::ttsheng-dbs3/sqlserver/Store.csv', 
@rds_file_path='D:\S3\seed_data\Store.csv', 
@overwrite_file=1;
go
exec msdb.dbo.rds_download_from_s3
@s3_arn_of_file='arn:aws:s3:::ttsheng-dbs3/sqlserver/TransactionHistoryArchive.csv', 
@rds_file_path='D:\S3\seed_data\TransactionHistoryArchive.csv', 
@overwrite_file=1;
go
exec msdb.dbo.rds_download_from_s3
@s3_arn_of_file='arn:aws:s3:::ttsheng-dbs3/sqlserver/TransactionHistory.csv', 
@rds_file_path='D:\S3\seed_data\TransactionHistory.csv', 
@overwrite_file=1;
go
exec msdb.dbo.rds_download_from_s3
@s3_arn_of_file='arn:aws:s3:::ttsheng-dbs3/sqlserver/UnitMeasure.csv', 
@rds_file_path='D:\S3\seed_data\UnitMeasure.csv', 
@overwrite_file=1;
go
exec msdb.dbo.rds_download_from_s3
@s3_arn_of_file='arn:aws:s3:::ttsheng-dbs3/sqlserver/Vendor.csv', 
@rds_file_path='D:\S3\seed_data\Vendor.csv', 
@overwrite_file=1;
go
exec msdb.dbo.rds_download_from_s3
@s3_arn_of_file='arn:aws:s3:::ttsheng-dbs3/sqlserver/WorkOrder.csv', 
@rds_file_path='D:\S3\seed_data\WorkOrder.csv', 
@overwrite_file=1;
go
exec msdb.dbo.rds_download_from_s3
@s3_arn_of_file='arn:aws:s3:::ttsheng-dbs3/sqlserver/WorkOrderRouting.csv', 
@rds_file_path='D:\S3\seed_data\WorkOrderRouting.csv', 
@overwrite_file=1;
go
