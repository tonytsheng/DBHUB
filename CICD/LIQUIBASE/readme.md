## Create the liquibase.properties file
See example file.
Place the postgresql jar in the same directory [or maybe in LD_LIBRARY_PATH or PATH]

## baseline - first glance at what is in the database
liquibase --changeLogFile=pg102.init.sql generate-changelog

## allows you to check the sql file contents
liquibase changelog-sync-sql --changelog-file pg102.init.sql

## applies this baseline to the Liquibase tracking tables in your database
liquibase changelog-sync --changelog-file pg102.init.sql

## databasechangelog table
```
       id        |  author  |    filename    |        dateexecuted        | orderexecuted | exectype |               md5sum
             | description | comments | tag | liquibase | contexts | labels | deployment_id
-----------------+----------+----------------+----------------------------+---------------+----------+-----------------------
-------------+-------------+----------+-----+-----------+----------+--------+---------------
 1681318361353-1 | ec2-user | pg102.init.sql | 2023-04-12 16:54:01.545299 |             1 | EXECUTED | 8:23439116be78e5f71f47
952707a7299d | sql         |          |     | 4.15.0    |          |        | 1318441539
 1681318361353-2 | ec2-user | pg102.init.sql | 2023-04-12 16:54:01.59676  |             2 | EXECUTED | 8:3ca3b8828818bc1490f5
8f83ff7578ce | sql         |          |     | 4.15.0    |          |        | 1318441539
 1681318361353-3 | ec2-user | pg102.init.sql | 2023-04-12 16:54:01.60033  |             3 | EXECUTED | 8:0258e471621dfbf2e0e4
dc027f48914c | sql         |          |     | 4.15.0    |          |        | 1318441539
 1681318361353-4 | ec2-user | pg102.init.sql | 2023-04-12 16:54:01.604488 |             4 | EXECUTED | 8:af55cfe2a0bb9053b5fa
1398d9bc52b6 | sql         |          |     | 4.15.0    |          |        | 1318441539
 1681318361353-5 | ec2-user | pg102.init.sql | 2023-04-12 16:54:01.608021 |             5 | EXECUTED | 8:81913f8833a56304ef27
41f00e43aada | sql         |          |     | 4.15.0    |          |        | 1318441539
 1681318361353-6 | ec2-user | pg102.init.sql | 2023-04-12 16:54:01.611856 |             6 | EXECUTED | 8:574f5f95ff39ae6ead35
f5b2429feaa0 | sql         |          |     | 4.15.0    |          |        | 1318441539
(6 rows)
```

## Use a different properties file
liquibase --defaultsFile=liquibase.properties.pg201 update --changeLogFile=pg102.2.sql
applying the changes from pg102 to pg201.

## Diff
liquibase diff --defaultsFile=liquibase.properties.diff.pg102_pg201 --output-file=diff.sql
note the output is not in sql format so can't be easily applied

