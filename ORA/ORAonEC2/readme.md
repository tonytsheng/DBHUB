## Performance testing self managed Oracle on EC2.
Some customers do not have the option of running their databases in RDS. The reasons for this vary, from their database size, to COTS application requirements to very large IOPS requirements. When customers run into these or similar issues, sometimes a self managed databases running on an EC2 instance can be a good option. Running on EC2 allows customers to leverage AWS for some of the traditional IT maintenance tasks. In these circumstances, it is always valuable to also consider RDS Custom.

These artifacts in this library reference some simple performance tests for a self managed Oracle database running on an EC2 instance. Note the following:
1. SLOB was used as the tool to generate application load. There was no tuning of application code although that is usually the best return on investment. 
2. The baseline was an Oracle database with default parameters, an SGA of 2G, with data files sitting on EBS volumes.
3. We then compared to putting data files on instance store volumes.
4. We then turned on Smart Flash Cache and the file for the Cache was also placed on an instance store volume.
4. We then increased the SGA to 10G. Note the server has 16G of memory. This did not give us an improvement in performance like expected.
5. We increased the db_writer_processes to 5 from the default of 1 and that was a notable increase in pefformance. Note that this was a recommendation in the very first AWR report.
6. We then increased db_writer_processes to 10, just to see what else would happen.

### Baseline
- i3en.large - 2x16
  - oracle sitting on /u01
  - not using asm
  - data files built right on file system
```    
  - ebs - /dev/nvme2n1p1  100G  2.3G   98G   3% /
  - ebs - /dev/nvme0n1p1  493G  334G  134G  72% /u01
  - nvme - /dev/nvme1n1    1.2T  2.1G  1.1T   1% /fast
```
  - Notable Oracle parameters that were tuned:
    - sga_target
    - db_writer_processes

### Smart Flash Cache 
```
SQL> alter system set db_flash_cache_file = '/fast/oradata/flash/cache1' scope=spfile;

System altered.

SQL> alter system set db_flash_cache_size=2G scope=spfile;

System altered.

SQL> shutdown immediate
Database closed.
Database dismounted.
ORACLE instance shut down.
SQL> startup
ORACLE instance started.

Total System Global Area 2147483648 bytes
Fixed Size                  8622776 bytes
Variable Size             704646472 bytes
Database Buffers         1426063360 bytes
Redo Buffers                8151040 bytes
Database mounted.
Database opened.
SQL> show parameter flash

NAME                                 TYPE        VALUE
------------------------------------ ----------- ------------------------------
db_flash_cache_file                  string      /fast/oradata/flash/cache1
db_flash_cache_size                  big integer 2G
db_flashback_retention_target        integer     1440
```
### SLOB parameters:
See https://kevinclosson.net/slob/. Also note that the SLOB profile was identical through all the testing.
  - 15 schemas: ./setup.sh tablespacename 15
  - UPDATE_PCT: 25
  - SCAN_PCT: 10
  - RUN_TIME: 3600
  - WORK_LOOP: 0
  - SCALE: 800M (51200 blocks)
  - WORK_UNIT: 64
  - REDO_STRESS: LITE
  - hot spot off
  - think time off

### Outputs to compare:
  - AWR report, generated automatically by SLOB
  - iostat, generated automatically by SLOB
  - Various AWR metrics

### Results 
- Test #1 - Data files on EBS, SGA at 2G.
- #2 - Data files on NVMe, SGA at 2G.
- #3 - Data files on NVMe, SGA at 2G, Smart Flash Cache turned on at 2G.
- #4 - Data files on NVMe, SGA at 10G, Smart Flash Cache turned on at 10G.
- #5 - Data files on NVMe, SGA at 10G, Smart Flash Cache turned on at 10G, db_writer_processes=5.
- #6 - Data files on NVMe, SGA at 10G, Smart Flash Cache turned on at 10G, db_writer_processes=10.

| Metric           |  Test 1 |   2    | 3      | 4      | 5      |  6    |
| ----             | ----    | ------ | ----   | -----  | ------ | ----  |
| Logical read/s   |  6,628  | 34,202 | 37,474 | 17,147 | 50,472 | 56,715|
| Physical read/s  |  4,129  | 19,041 | 10,392 | 226    | 1,065  | 1,143 |
| Physical write/s |  1,605  | 8,101  |  6,795 | 2,707  | 6,220  | 9,543 |
| Executes/s       |   82    |  421   |  462   | 216    | 621    | 696   |
| Transactions/s   |   19    |  104   |  114   | 52     | 150    | 173   |

|                                       |     Test 1 |   2        |  3        | 4      | 5         |  6    |
| -------------                         |  --------  |  ----      | ----      | ----   | -------   | ----  |
|Executions of the most expensive query |   192,776  |  1,013,242 | 1,110,225 | 35,116 | 1,472,365 | 1,687,701 |
|*consistent at 65.2 gets/execution     |

### Conclusion TODO
- In this simple test, performance with just NVMe volumes is much greater than running on EBS volumes, understandbly. The downside to this is that instance store volumes do not persist if your EC2 instance is stopped and started [note - not just rebooted]. If considering this because of IOPS requirements, also consider some kind of database redunndancy, like replication. The ideal use case is when data can be re-ingested since NVMe volumes will not persist when the EC2 instance is stopped and stared.
- Smart Flash Cache is definitely worth testing.
- Increasing the db_writer_processes [how many DBWR processes are running on the server] is a worthwhile adjustment.
- The size of the SGA for this test with 2G and the Smart Flash Cache size was the same. This instance had 
