#!/bin/bash

#DB_PW=`/home/ec2-user/DBHUB/BIN/getsecret.cli`

# postgreSQL connection environment variables
export BENCHMARK_HOST=aur100.cluster-ro-cyt4dgtj55oy.us-east-2.rds.amazonaws.com
export BENCHMARK_PORT=5432
export BENCHMARK_DB=aur100
export PGPASSWORD=Pass1234
export BENCHMARK_USER=postgres
# pgbench control environment variables
export BENCHMARK_CONNECTIONS=90
export BENCHMARK_THREADS=20
export BENCHMARK_SQL_FILE=/home/ec2-user/DBHUB/PERFTUNE/AURORA_READER_AUTOSCALE/tx_group1.sql 
# time in seconds to run test
export BENCHMARK_TIME=600
# run the benchmark test
cd /home/ec2-user/DBHUB/PERFTUNE/AURORA_READER_AUTOSCALE

# SYNTAX FOR RUNNING FOR A SPECIFIC AMOUNT OF TIME IN SECONDS
/usr/pgsql-12/bin/pgbench -c $BENCHMARK_CONNECTIONS -j $BENCHMARK_THREADS -T $BENCHMARK_TIME -U $BENCHMARK_USER -d $BENCHMARK_DB -h $BENCHMARK_HOST -p $BENCHMARK_PORT -S -f $BENCHMARK_SQL_FILE | tee -a /home/ec2-user/DBHUB/PERFTUNE/AURORA_READER_AUTOSCALE/log.out

# -S select only - see sql file
