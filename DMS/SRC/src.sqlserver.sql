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


+++
1> create login dms_adventureworks with password ='Pass1234', default_database=Adventureworks
2> go
1> create user dms_adventureworks for login dms_adventureworks;
2> go
1> alter role [db_datareader] for dms_adventureworks
2> go
Msg 156, Level 15, State 1, Server EC2AMAZ-H3P2F0R, Line 1
Incorrect syntax near the keyword 'for'.
1> alter role  [db_datareader] add member dms_adventureworks
2> go
1> use master
2> go
Changed database context to 'master'.
1> grant view server state to dms_adventureworks
2> go


