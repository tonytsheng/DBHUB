#!/bin/tclsh

puts "SETTING CONFIGURATION"

global complete
proc wait_to_complete {} {
global complete
set complete [vucomplete]
if {!$complete} {after 5000 wait_to_complete} else { exit }
}

dbset db pg
diset connection pg_host pg1001.czzdit7hfndz.us-east-2.rds.amazonaws.com
diset connection pg_port 5432
diset tpcc pg_num_vu 1
diset tpcc pg_superuser postgres
diset tpcc pg_superuserpass Pass1234
diset tpcc pg_defaultdbase pg1001
diset tpcc pg_user tpcc
diset tpcc pg_pass tpcc
diset tpcc pg_dbase tpcc
print dict
buildschema
wait_to_complete
