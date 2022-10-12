## Performance testing self managed Oracle on EC2.
Some customers do not have the option of running their databases in RDS. The reasons for this vary, from their database size, to COTS application requirements to very large IOPS requirements. When customers run into these or similar issues, sometimes a self managed databases running on an EC2 instance can be a good option. Running on EC2 allows customers to leverage AWS for some of the traditional IT maintenance tasks. In these circumstances, it is always valuable to also consider RDS Custom.

These artifacts in this library reference some simple performance tests done for 3 scenarios for a self managed Oracle database running on an EC2 instance:
1. A baseline performance test using SLOB and Oracle data files on EBS volumes.
2. Oracle data files on instance store volumes.
3. Turn on Smart Flash Cache.
4. Increase the SGA to 10G, data on instance store volumes, Smart Flash Cache turned off.
5. Same as #4, but turn Smart Flash Cache back on.

### Baseline:
- i3en.large - 2x16
  - oracle sitting on /u01
  - not using asm
  - data files built right on file system
```    
  - ebs - /dev/nvme2n1p1  100G  2.3G   98G   3% /
  - ebs - /dev/nvme0n1p1  493G  334G  134G  72% /u01
  - nvme - /dev/nvme1n1    1.2T  2.1G  1.1T   1% /fast
```
  - Notable Oracle parameters
    - SGA - 2G
### Instance store test:
  - tablespace created on instance store
  - all user data located on that tablespace
  - redo/archive log still on regular /u01 EBS volume

### Smart Flash Cache test:
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

| Metric           |    EBS 2G     |   NVMe 2G   | SmartCache 2G | NVMe 10G | SmartCache 10G DBWR|
| ----             | ----------    | --------    | ----------    |  -----  | ---------- |
| Logical read/s   |  6,628.1      | 34,202.6    |   37,474.7    |  17,147 | 50,472
| Physical read/s  |  4,129.9      | 19,041.1    |   10,392      |  226    | 1065
| Physical write/s |  1,605.1      | 8,101.0     |    6,795       |  2,707 | 6220
| Executes/s       |   82.5        |  421.7      |    462        |  216    | 621
| Transactions/s   |   19.9        |  104.2      |    114        |  52.1   | 150.6


|                                  |     EBS 2G    |    NVMe 2G   | SmartCache 2G | NVMe 10G | SmartCache 10G |
| -------------                    |  --------     |   -------    | ---------     | -------- | ------- |
|Executions of most expensive query |   192,776    |  1,013,242   | 1,110,225     |  35,116 | 1,472,365

*consistent at 65.2 gets/execution

|              |   EBS 2G   |  NVMe 2G  |  SmartCache 2G | NVMe 10G | SmartCache 10G 
| ----         | -------    | ------    |  -------       |  --------  |----
| AWR IOPS     |   5413     |  25170    |   15840        | 2852       |6234


### Conclusion
- In this simple test, performance with just NVMe volumes is much greater than running on EBS volumes, understandbly. The downside to this is that instance store volumes do not persist if your EC2 instance is stopped and started [note - not just rebooted]. If considering this because of IOPS requirements, also consider some kind of database redunndancy, like replication. The ideal use case is when data can be re-ingested since NVMe volumes will not persist when the EC2 instance is stopped and stared.
- Performance is a bit better when turning on Smart Flash Cache. Note that physical reads and IOPS both drop a bit but transactions per second and executions of the most expensive query have both increased slightly. The database is doing more work with less IO.
- The size of the SGA for this test with 2G and the Smart Flash Cache size was the same. This instance had 
