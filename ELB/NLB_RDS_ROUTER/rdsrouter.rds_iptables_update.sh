#!/bin/bash
date
for i in {1..5}
do
  RDS_CONNECTION_IP=`nslookup mysqldb1.c93uuztwxxsv.us-east-1.rds.amazonaws.com | egrep "^Address" | grep -v "#53" | awk '{print $2}'`
  #echo "## Current RDS_CONNECTION_IP : " $RDS_CONNECTION_IP
  set -x
  /sbin/iptables -t nat -R PREROUTING 1 -i eth0 -p tcp --dport 3306 -j DNAT --to $RDS_CONNECTION_IP:3306
  set +x
  sleep 10
done

