use FLY1
go
exec sys.sp_cdc_enable_table
@source_schema = N'FLY1',
@source_name = N'airline',
@role_name = NULL,
@supports_net_changes = 1
GO
exec sys.sp_cdc_enable_table
@source_schema = N'FLY1',
@source_name = N'airport',
@role_name = NULL,
@supports_net_changes = 1
go
exec sys.sp_cdc_enable_table
@source_schema = N'FLY1',
@source_name = N'employee',
@role_name = NULL,
@supports_net_changes = 1
go
exec sys.sp_cdc_enable_table
@source_schema = N'FLY1',
@source_name = N'reservation',
@role_name = NULL,
@supports_net_changes = 1
go

