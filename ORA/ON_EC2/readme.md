## Performance testing self managed Oracle on EC2.
Some teams have IOPS demands that they need to maintain.  They want to do this with a self-managed Oracle database running on EC2.  This will allow them to spin up instances rather quickly, but still maintain full control of their databases.

These artifacts in this library reference some performance tests for a self-managed Oracle database running on an EC2 instance. The following tests were run:
1. A baseline test. Note this baseline test was using an instance shape of ien.large, which is a 2x16 machine.
2. Changed instance shape to ien.24xlarge. Increased the size of logfiles from 2G to 5G.
3. Increase the log buffer size rom 131MB to 10G.
4. Increase the log_archive_max_processes from 4 to 20.
5. Spread logfiles across the /u01 /u02 and /u03 filesystems.
6. Increase the size of the logfiles from 5G to 20G - logs were rotating at every 2-3 minutes
    - spread logfiles across u02 u03 u04 instead of on u01
7. Increase the size of logfiles from 20G to 40G.
8. Increase the size of logfiles from 40G to 60G.
    - changed db_recovery_file_dest to /u04 - archived logs writing instead of /u01
9. Increase the shared pool size from 0 to 78G.
10. Increase the shared pool from 78G to 200G.
11. Decrease the shared pool from 200G to 100G.
12. Decrease the shared pool from 100G to 80G.
13. Pin user tables to the smart flash cache.
14. Set filesystemio_options from NONE to SETALL.

### Baseline
- ien.24xlarge
  - 96 cpus x 768 memory
  - oracle sga - 700G
  - flash cache across 8 instance store volumes - 200G each - 1600G
  - tempfiles - 8 across instance store volumes - 16G each - 128G
  - User data was placed on EBS volumes.

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

### Results 
Test    | Log read/s | Phys read/s | Phys write/s | Executes/s | Transactions/s | Execs of most exp query* |
---     | ----      |   -----      |   ------         | ------     | ---------      |  --------               |
Baseline| 66,991    | 1,638 | 9,342  | 824   | 204   | 1,989,971  |
2       | 41,735    | .8    | 5,772  | 511   | 124   | 1,249,562  |
3       | 40,755    | 333   | 5,573  | 501   | 124   | 1,224,431  |
4       |43,214     | 0.2   | 4,202  | 528   | 131   | 1,290,303  |
5       | NA        |       |        |       |       |       |
6       | 83,120    | 0.2   | 4,536  | 1,016 | 253   | 2,471,303  |
7       | 133,312   |325    | 4,894  | 1,633 | 407   | 3,963,227  |
8       | 121,897   | 0.2   | 3,384  | 1,491 | 372   | 3,631,911  |
9       | 154,95    | 4.2   | 4,285  | 1,900 | 472   | 4,606,302  |
10      | 133,194   | 336   | 5,556  | 1,632 | 406   | 3,953,952  |
11      | 128,724   | 335   | 3,838  | 1,578 | 392   | 3,839,860  |
12      | 152,165   | 335   | 4,277  | 1,864 | 464   | 4,533,680  |
13      | 120,531   | .3    | 3,131  | 1,474 | 368   | 3,595,694  |
14      | 395,464   | 332   | 1,604  | 4,830 | 1,180 | 11,621,071 |

*consistent at 65.2 gets/execution

### Conclusion
- The biggest increase in performance was setting filesystemio_options. Adjusting shared pool had non-intuitive results. Surprisingly, pinning user tables to the smart flash cache resulted in a slight performance decrease.
- Automatic Memory Management and adjusting the PGA were both not tested here but might be worthwhile to test.
- This was a simple test. Like with most things Oracle, there could be more details to tune.
