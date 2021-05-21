>> cat pgrun.tcl

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
if {  [ vucomplete ] || $x eq $seconds } { set timerstop 1 }
    }
return
}

puts "SETTING CONFIGURATION"
dbset db pg
diset connection pg_host pg500-instance-1.cyt4dgtj55oy.us-east-2.rds.amazonaws.com
diset connection pg_port 5432
diset tpcc pg_driver timed
diset tpcc pg_rampup 5
diset tpcc pg_duration 25
diset tpcc pg_vacuum true
print dict
vuset logtotemp 1
loadscript
puts "SEQUENCE STARTED"
foreach z { 1 16 32 64 128 256 512 } {
puts "$z VU TEST"
vuset vu $z
vucreate
vurun
runtimer 9000
vudestroy
after 5000
}
puts "TEST SEQUENCE COMPLETE"
exit
