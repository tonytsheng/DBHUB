select name, is_cdc_enabled from master.sys.databases

-- for RDS
exec msdb.dbo.rds_cdc_enable_db 'fly1'
go
use fly1
go
exec sys.sp_cdc_enable_table
@source_schema = N'dbo',
@source_name = N'airline',
@role_name = NULL,
@supports_net_changes = 1
go
exec sys.sp_cdc_enable_table
@source_schema = N'dbo',
@source_name = N'airport',
@role_name = NULL,
@supports_net_changes = 1
go
exec sys.sp_cdc_enable_table
@source_schema = N'dbo',
@source_name = N'employee',
@role_name = NULL,
@supports_net_changes = 1
go
exec sys.sp_cdc_enable_table
@source_schema = N'dbo',
@source_name = N'reservation',
@role_name = NULL,
@supports_net_changes = 1
go

use fly1
go
EXEC sys.sp_cdc_change_job @job_type = 'capture' ,@pollinginterval = 86399
go
exec sp_cdc_stop_job 'capture'
go
exec sp_cdc_start_job 'capture'
go

