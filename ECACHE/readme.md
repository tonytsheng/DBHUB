Simple POC for ElastiCache and PostgreSQL
====

- ElastiCache Redis cluster
- RDS for PostgreSQL database
- reference data
- python code

loadairport.py
---
simple example to load airport data from csv file into redis EC

queryairport.py
---
simple example to query either pg database or redis EC
based on input pararmeter

execution
---
5 executions and use the time command to watch performance

% time (for i in {1..5}; do python queryairport.py cache|database ;echo "";done)
