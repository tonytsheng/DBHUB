#!/bin/tclsh
proc runtimer { seconds } {
set x 0
set timerstop 0
while {!$timerstop} {
incr x
after 1000
if { ![ expr {$x % 60} ] } {
set y [ expr $x / 60 ]
puts "Timer: $y minutes elapsed"
}
update
if { [ vucomplete ] || $x eq $seconds } { set timerstop 1 }
}
return
}

puts "SETTING CONFIGURATION"
dbset db pg
diset connection pg_host pg1001.czzdit7hfndz.us-east-2.rds.amazonaws.com
diset connection pg_port 5432
diset tpcc pg_superuser postgres
diset tpcc pg_superuserpass Pass1234
diset tpcc pg_defaultdbase pg1001
diset tpcc pg_user tpcc
diset tpcc pg_pass tpcc
diset tpcc pg_dbase tpcc
diset tpcc pg_driver timed
diset tpcc pg_duration 2
diset tpcc pg_duration 5
diset tpcc pg_vacuum true
print dict
vuset logtotemp 1
loadscript
puts "SEQUENCE STARTED"
#foreach z { 1 16 32 64 128 256 512 1024 2048} {
#foreach z { 1 16 } {
puts "$z VU TEST"
vuset vu $z
vucreate
vurun
runtimer 10000
vudestroy
after 5000
}
puts "TEST SEQUENCE COMPLETE"
exit
