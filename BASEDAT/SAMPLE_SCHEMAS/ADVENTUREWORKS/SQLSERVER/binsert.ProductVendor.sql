BULK INSERT [Purchasing].[ProductVendor] FROM 'D:\S3\seed_data\ProductVendor.csv'
WITH (
    CHECK_CONSTRAINTS,
    CODEPAGE='ACP',
    DATAFILETYPE='char',
    FIELDTERMINATOR='\t',
    ROWTERMINATOR='\n',
    KEEPIDENTITY,
    TABLOCK
);

