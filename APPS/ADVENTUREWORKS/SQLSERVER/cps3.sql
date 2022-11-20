exec msdb.dbo.rds_download_from_s3
@s3_arn_of_file='arn:aws:s3:::ttsheng-dbs3/sqlserver/ProductVendor.csv',
@rds_file_path='D:\S3\seed_data\ProductVendor.csv',
@overwrite_file=1;
go

