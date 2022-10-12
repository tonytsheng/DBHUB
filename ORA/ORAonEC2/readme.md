## Performance testing self managed Oracle on EC2.
For some customers, RDS is not an option for running their databases. It could be that their databases are either too large, their IOPS requirements are too great, they need more control their an RDS instance can provide or some other reason. When customers run into these or similar issues, sometimes a self managed databases running on an EC2 instance can be a good option. Running on EC2 allows customers to leverage AWS for some of the traditional IT maintenance tasks.

These artifacts in this library reference some simple performance tests done for 3 scenarios for a self managed Oracle database running on an EC2 instance:
1. A baseline performance test using SLOB and Oracle data files on EBS volumes.
2. Oracle data files on instance store volumes.
3. Turn on smart flash cache.

- Baseline:
  - i3en.large - 2x16
    - ebs - /dev/nvme2n1p1  100G  2.3G   98G   3% /
    - ebs - /dev/nvme0n1p1  493G  334G  134G  72% /u01
    - nvme - /dev/nvme1n1    1.2T  2.1G  1.1T   1% /fast
    - oracle sitting on /u01
    - not using asm
    - data files built right on file system
  - Notable Oracle parameters
    - SGA - 2G
- Instance store test:
    - tablespace created on instance store
    - all user data located on that tablespace
    - redo/archive log still on regular /u01 EBS volume
- Smart Flash Cache test:

- SLOB parameters:
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

- Outputs to compare:
  - AWR report, generated automatically by SLOB
  - iostat, generated automatically by SLOB
  - Various AWR metrics

| Metric           |    EBS     |   NVME   | SmartCache |
| ----             | ---------- | -------- | ---------- |
| Logical read/s   |  6,628.1   | 34,202.6 | 
| Physical read/s  |  4,129.9   | 19,041.1 | 
| Physical write/s |  1,605.1   | 8,101.0  | 
| Executes/s       |   82.5     |  421.7   |
| Transactions/s   |   19.9     |  104.2   |

|                                  |     EBS     |    NVME    | SmartCache |
| -------------                    |  --------   |   -------  | ---------  |
|Executions of most expensive query |   192,776   |  1,013,242 |   | 

*consistent at 65.2 gets/execution

|              |   EBS    |  NVME  |  SmartCache |
| ----         | -------  | ------ |  -------    |
| AWR IOPS     |   5413   |  25170 |             |


- smart flash cache
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
