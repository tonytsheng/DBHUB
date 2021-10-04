use adventureworks
go
ALTER TABLE [Person].[Address] DROP CONSTRAINT [FK_Address_StateProvince_StateProvinceID]  
go

ALTER TABLE [Production].[BillOfMaterials] DROP CONSTRAINT [FK_BillOfMaterials_Product_ProductAssemblyID]  
go

ALTER TABLE [Production].[BillOfMaterials] DROP CONSTRAINT [FK_BillOfMaterials_Product_ComponentID]  
go

ALTER TABLE [Production].[BillOfMaterials] DROP CONSTRAINT [FK_BillOfMaterials_UnitMeasure_UnitMeasureCode]  
go

ALTER TABLE [Person].[BusinessEntityAddress] DROP CONSTRAINT [FK_BusinessEntityAddress_Address_AddressID]  
go

ALTER TABLE [Person].[BusinessEntityAddress] DROP CONSTRAINT [FK_BusinessEntityAddress_AddressType_AddressTypeID]  
go

ALTER TABLE [Person].[BusinessEntityAddress] DROP CONSTRAINT [FK_BusinessEntityAddress_BusinessEntity_BusinessEntityID]  
go

ALTER TABLE [Person].[BusinessEntityContact] DROP CONSTRAINT [FK_BusinessEntityContact_Person_PersonID]  
go

ALTER TABLE [Person].[BusinessEntityContact] DROP CONSTRAINT [FK_BusinessEntityContact_ContactType_ContactTypeID]  
go

ALTER TABLE [Person].[BusinessEntityContact] DROP CONSTRAINT [FK_BusinessEntityContact_BusinessEntity_BusinessEntityID]  
go

ALTER TABLE [Sales].[CountryRegionCurrency] DROP CONSTRAINT [FK_CountryRegionCurrency_CountryRegion_CountryRegionCode]  
go

ALTER TABLE [Sales].[CountryRegionCurrency] DROP CONSTRAINT [FK_CountryRegionCurrency_Currency_CurrencyCode]  
go

ALTER TABLE [Sales].[CurrencyRate] DROP CONSTRAINT [FK_CurrencyRate_Currency_FromCurrencyCode]  
go

ALTER TABLE [Sales].[CurrencyRate] DROP CONSTRAINT [FK_CurrencyRate_Currency_ToCurrencyCode]  
go

ALTER TABLE [Sales].[Customer] DROP CONSTRAINT [FK_Customer_Person_PersonID]  
go

ALTER TABLE [Sales].[Customer] DROP CONSTRAINT [FK_Customer_Store_StoreID]  
go

ALTER TABLE [Sales].[Customer] DROP CONSTRAINT [FK_Customer_SalesTerritory_TerritoryID]  
go

ALTER TABLE [Production].[Document] DROP CONSTRAINT [FK_Document_Employee_Owner] 
go

ALTER TABLE [Person].[EmailAddress] DROP CONSTRAINT [FK_EmailAddress_Person_BusinessEntityID]  
go

ALTER TABLE [HumanResources].[Employee] DROP CONSTRAINT [FK_Employee_Person_BusinessEntityID]  
go

ALTER TABLE [HumanResources].[EmployeeDepartmentHistory] DROP CONSTRAINT [FK_EmployeeDepartmentHistory_Department_DepartmentID]  
go

ALTER TABLE [HumanResources].[EmployeeDepartmentHistory] DROP CONSTRAINT [FK_EmployeeDepartmentHistory_Employee_BusinessEntityID]  
go

ALTER TABLE [HumanResources].[EmployeeDepartmentHistory] DROP CONSTRAINT [FK_EmployeeDepartmentHistory_Shift_ShiftID]  
go

ALTER TABLE [HumanResources].[EmployeePayHistory] DROP CONSTRAINT [FK_EmployeePayHistory_Employee_BusinessEntityID]  
go

ALTER TABLE [HumanResources].[JobCandidate] DROP CONSTRAINT [FK_JobCandidate_Employee_BusinessEntityID]  
go

ALTER TABLE [Person].[Password] DROP CONSTRAINT [FK_Password_Person_BusinessEntityID]  
go

ALTER TABLE [Person].[Person] DROP CONSTRAINT [FK_Person_BusinessEntity_BusinessEntityID]  
go

ALTER TABLE [Sales].[PersonCreditCard] DROP CONSTRAINT [FK_PersonCreditCard_Person_BusinessEntityID]  
go

ALTER TABLE [Sales].[PersonCreditCard] DROP CONSTRAINT [FK_PersonCreditCard_CreditCard_CreditCardID]  
go

ALTER TABLE [Person].[PersonPhone] DROP CONSTRAINT [FK_PersonPhone_Person_BusinessEntityID]  
go

ALTER TABLE [Person].[PersonPhone] DROP CONSTRAINT [FK_PersonPhone_PhoneNumberType_PhoneNumberTypeID]  
go

ALTER TABLE [Production].[Product] DROP CONSTRAINT [FK_Product_UnitMeasure_SizeUnitMeasureCode]  
go

ALTER TABLE [Production].[Product] DROP CONSTRAINT [FK_Product_UnitMeasure_WeightUnitMeasureCode]  
go

ALTER TABLE [Production].[Product] DROP CONSTRAINT [FK_Product_ProductModel_ProductModelID]  
go

ALTER TABLE [Production].[Product] DROP CONSTRAINT [FK_Product_ProductSubcategory_ProductSubcategoryID]  
go

ALTER TABLE [Production].[ProductCostHistory] DROP CONSTRAINT [FK_ProductCostHistory_Product_ProductID]  
go

ALTER TABLE [Production].[ProductDocument] DROP CONSTRAINT [FK_ProductDocument_Product_ProductID]  
go

ALTER TABLE [Production].[ProductDocument] DROP CONSTRAINT [FK_ProductDocument_Document_DocumentNode]  
go

ALTER TABLE [Production].[ProductInventory] DROP CONSTRAINT [FK_ProductInventory_Location_LocationID]  
go

ALTER TABLE [Production].[ProductInventory] DROP CONSTRAINT [FK_ProductInventory_Product_ProductID]  
go

ALTER TABLE [Production].[ProductListPriceHistory] DROP CONSTRAINT [FK_ProductListPriceHistory_Product_ProductID]  
go

ALTER TABLE [Production].[ProductModelIllustration] DROP CONSTRAINT [FK_ProductModelIllustration_ProductModel_ProductModelID]  
go

ALTER TABLE [Production].[ProductModelIllustration] DROP CONSTRAINT [FK_ProductModelIllustration_Illustration_IllustrationID]  
go

ALTER TABLE [Production].[ProductModelProductDescriptionCulture] DROP CONSTRAINT [FK_ProductModelProductDescriptionCulture_ProductDescription_ProductDescriptionID]  
go

ALTER TABLE [Production].[ProductModelProductDescriptionCulture] DROP CONSTRAINT [FK_ProductModelProductDescriptionCulture_Culture_CultureID]  
go

ALTER TABLE [Production].[ProductModelProductDescriptionCulture] DROP CONSTRAINT [FK_ProductModelProductDescriptionCulture_ProductModel_ProductModelID]  
go

ALTER TABLE [Production].[ProductProductPhoto] DROP CONSTRAINT [FK_ProductProductPhoto_Product_ProductID]  
go

ALTER TABLE [Production].[ProductProductPhoto] DROP CONSTRAINT [FK_ProductProductPhoto_ProductPhoto_ProductPhotoID]  
go

ALTER TABLE [Production].[ProductReview] DROP CONSTRAINT [FK_ProductReview_Product_ProductID]  
go

ALTER TABLE [Production].[ProductSubcategory] DROP CONSTRAINT [FK_ProductSubcategory_ProductCategory_ProductCategoryID]  
go

ALTER TABLE [Purchasing].[ProductVendor] DROP CONSTRAINT [FK_ProductVendor_Product_ProductID]  
go

ALTER TABLE [Purchasing].[ProductVendor] DROP CONSTRAINT [FK_ProductVendor_UnitMeasure_UnitMeasureCode]  
go

ALTER TABLE [Purchasing].[ProductVendor] DROP CONSTRAINT [FK_ProductVendor_Vendor_BusinessEntityID]  
go

ALTER TABLE [Purchasing].[PurchaseOrderDetail] DROP CONSTRAINT [FK_PurchaseOrderDetail_Product_ProductID]  
go

ALTER TABLE [Purchasing].[PurchaseOrderDetail] DROP CONSTRAINT [FK_PurchaseOrderDetail_PurchaseOrderHeader_PurchaseOrderID]  
go

ALTER TABLE [Purchasing].[PurchaseOrderHeader] DROP CONSTRAINT [FK_PurchaseOrderHeader_Employee_EmployeeID]  
go

ALTER TABLE [Purchasing].[PurchaseOrderHeader] DROP CONSTRAINT [FK_PurchaseOrderHeader_Vendor_VendorID]  
go

ALTER TABLE [Purchasing].[PurchaseOrderHeader] DROP CONSTRAINT [FK_PurchaseOrderHeader_ShipMethod_ShipMethodID]  
go

ALTER TABLE [Sales].[SalesOrderDetail] DROP CONSTRAINT [FK_SalesOrderDetail_SalesOrderHeader_SalesOrderID]  
go

ALTER TABLE [Sales].[SalesOrderDetail] DROP CONSTRAINT [FK_SalesOrderDetail_SpecialOfferProduct_SpecialOfferIDProductID]  
go

ALTER TABLE [Sales].[SalesOrderHeader] DROP CONSTRAINT [FK_SalesOrderHeader_Address_BillToAddressID]  
go

ALTER TABLE [Sales].[SalesOrderHeader] DROP CONSTRAINT [FK_SalesOrderHeader_Address_ShipToAddressID]  
go

ALTER TABLE [Sales].[SalesOrderHeader] DROP CONSTRAINT [FK_SalesOrderHeader_CreditCard_CreditCardID]  
go

ALTER TABLE [Sales].[SalesOrderHeader] DROP CONSTRAINT [FK_SalesOrderHeader_CurrencyRate_CurrencyRateID]  
go

ALTER TABLE [Sales].[SalesOrderHeader] DROP CONSTRAINT [FK_SalesOrderHeader_Customer_CustomerID]  
go

ALTER TABLE [Sales].[SalesOrderHeader] DROP CONSTRAINT [FK_SalesOrderHeader_SalesPerson_SalesPersonID]  
go

ALTER TABLE [Sales].[SalesOrderHeader] DROP CONSTRAINT [FK_SalesOrderHeader_ShipMethod_ShipMethodID]  
go

ALTER TABLE [Sales].[SalesOrderHeader] DROP CONSTRAINT [FK_SalesOrderHeader_SalesTerritory_TerritoryID]  
go

ALTER TABLE [Sales].[SalesOrderHeaderSalesReason] DROP CONSTRAINT [FK_SalesOrderHeaderSalesReason_SalesReason_SalesReasonID]  
go

ALTER TABLE [Sales].[SalesOrderHeaderSalesReason] DROP CONSTRAINT [FK_SalesOrderHeaderSalesReason_SalesOrderHeader_SalesOrderID]  
go

ALTER TABLE [Sales].[SalesPerson] DROP CONSTRAINT [FK_SalesPerson_Employee_BusinessEntityID]  
go

ALTER TABLE [Sales].[SalesPerson] DROP CONSTRAINT [FK_SalesPerson_SalesTerritory_TerritoryID]  
go

ALTER TABLE [Sales].[SalesPersonQuotaHistory] DROP CONSTRAINT [FK_SalesPersonQuotaHistory_SalesPerson_BusinessEntityID]  
go

ALTER TABLE [Sales].[SalesTaxRate] DROP CONSTRAINT [FK_SalesTaxRate_StateProvince_StateProvinceID]  
go

ALTER TABLE [Sales].[SalesTerritory] DROP CONSTRAINT [FK_SalesTerritory_CountryRegion_CountryRegionCode] 
go

ALTER TABLE [Sales].[SalesTerritoryHistory] DROP CONSTRAINT [FK_SalesTerritoryHistory_SalesPerson_BusinessEntityID]  
go

ALTER TABLE [Sales].[SalesTerritoryHistory] DROP CONSTRAINT [FK_SalesTerritoryHistory_SalesTerritory_TerritoryID]  
go

ALTER TABLE [Sales].[ShoppingCartItem] DROP CONSTRAINT [FK_ShoppingCartItem_Product_ProductID]  
go

ALTER TABLE [Sales].[SpecialOfferProduct] DROP CONSTRAINT [FK_SpecialOfferProduct_Product_ProductID]  
go

ALTER TABLE [Sales].[SpecialOfferProduct] DROP CONSTRAINT [FK_SpecialOfferProduct_SpecialOffer_SpecialOfferID]  
go

ALTER TABLE [Person].[StateProvince] DROP CONSTRAINT [FK_StateProvince_CountryRegion_CountryRegionCode]  
go

ALTER TABLE [Person].[StateProvince] DROP CONSTRAINT [FK_StateProvince_SalesTerritory_TerritoryID]  
go

ALTER TABLE [Sales].[Store] DROP CONSTRAINT [FK_Store_BusinessEntity_BusinessEntityID] 
go

ALTER TABLE [Sales].[Store] DROP CONSTRAINT [FK_Store_SalesPerson_SalesPersonID]  
go

ALTER TABLE [Production].[TransactionHistory] DROP CONSTRAINT [FK_TransactionHistory_Product_ProductID]  
go

ALTER TABLE [Purchasing].[Vendor] DROP CONSTRAINT [FK_Vendor_BusinessEntity_BusinessEntityID] 
go

ALTER TABLE [Production].[WorkOrder] DROP CONSTRAINT [FK_WorkOrder_Product_ProductID]  
go

ALTER TABLE [Production].[WorkOrder] DROP CONSTRAINT [FK_WorkOrder_ScrapReason_ScrapReasonID]  
go

ALTER TABLE [Production].[WorkOrderRouting] DROP CONSTRAINT [FK_WorkOrderRouting_Location_LocationID]  
go

ALTER TABLE [Production].[WorkOrderRouting] DROP CONSTRAINT [FK_WorkOrderRouting_WorkOrder_WorkOrderID]  
go

