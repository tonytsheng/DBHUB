>> cat pgschemabuild.tcl

puts "SETTING CONFIGURATION"

global complete
proc wait_to_complete {} {
global complete
set complete [vucomplete]
if {!$complete} {after 5000 wait_to_complete} else { exit }
}

dbset db pg
diset connection pg_host pg500-instance-1.cyt4dgtj55oy.us-east-2.rds.amazonaws.com
diset connection pg_port 5432
diset tpcc pg_count_ware 50
diset tpcc pg_num_vu 10
diset tpcc pg_partition false
diset tpcc pg_superuser postgres
diset tpcc pg_superuserpass Pass1234
diset tpcc pg_defaultdbase pg500
diset tpcc pg_user tpcc
diset tpcc pg_pass tpcc
diset tpcc pg_dbase tpcc

print dict
buildschema
wait_to_complete
