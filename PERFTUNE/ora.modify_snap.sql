begin
	dbms_workload_repository.modify_snapshot_settings
	(interval => 30,
		retention=>86400 -- in minutes
	);
end;
/

