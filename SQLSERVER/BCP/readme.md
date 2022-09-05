## Quick BCP Example
- Scripts and files to support a quick example for using Bulk Copy Program (BCP) with RDS for MS SQL Server.
  - Set up your EC2 instance.
    - Download and install the appropriate drivers for MS SQL Server.
    - sqlcmd is the command line interface for MS SQL Server.
      - Using sqlcmd, create the database table that will hold the IMDB name data.
```
[ec2-user@ip-10-0-2-111 BCP]$ bcp imdb_name in /home/ec2-user/data/name3.tsv  -t"," -c -U fly1 -P fly1 -S sqlserver500.cyt4dgtj55oy.us-east-2.rds.amazonaws.com -d fly1 -e error.out

Starting copy...

1609002 rows copied.
Network packet size (bytes): 4096
Clock Time (ms.) Total     : 5056   Average : (318236.2 rows per sec.)
[ec2-user@ip-10-0-2-111 BCP]$ wc -l /home/ec2-user/data/name3.tsv
11773255 /home/ec2-user/data/name3.tsv
```

```
bcp imdb_name in /home/ec2-user/data/name3.tsv  -t"," -r "\n" -c -U fly1 -P fly1 -S sqlserver500.cyt4dgtj55oy.us-east-2.rds.amazonaws.com -d fly1 -e error.out
```
