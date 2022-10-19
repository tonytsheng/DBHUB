- ec2 ien24xlarge
- 96 cpus x 768 memory
- oracle sga - 700G
- flash cache across 8 instance store volumes - 200G each - 1600G
- tempfiles - 8 across instance store volumes - 16G each - 128G

2. increased redo member files from 2G to 5G - 3 groups of 3 each
3. increased log buffer from 131MB to 10G 
4. increased log_archive_max_processes from 4 to 20
5. spread logfiles across u01 u02 u03
6. increased logfiles from 5G to 20G - logs were rotating at every 2-3 minutes
  - spread logfiles across u02 u03 u04 instead of on u01
7. increased logfiles from 20G to 40G.
8. increased logfiles from 40G to 60G.
  - changed db_recovery_file_dest to /u04 - archived logs writing instead of /u01
9. adjust shared pool size from 0 to 78G
10. shared pool from 78G to 200G
11. shared pool from 200G to 100G
12. shared pool from 100G to 80G - results should look like #9
13. pin user tables to smart flash cache


Test    | Log read/s | Phys read/s | Phys write/s | Executes/s | Transactions/s | Execs of most exp query | 
---     | ----      |   -----      |   ------         | ------     | ---------      |  --------               |
1       | 66,991    | 1,638 | 9,342  | 824   | 204 | 1,989,971  |
2       | 41,735    | .8    | 5,772  | 511   | 124 | 1,249,562  |
3       | 40,755    | | 333 | 5,573  | 501   | 124 | 1,224,431  |
4       |43,214     | 0.2   | 4,202  | 528   | 131 | 1,290,303  |
5       | NA        |       |        |       |     |       NA   |
6       | 83,120    | 0.2   | 4,536  | 1,016 | 253 | 2,471,303  |
7       | 133,312   |325    | 4,894  | 1,633 | 407 | 3,963,227  |
8       | 121,897   | 0.2   | 3,384  | 1,491 | 372 | 3,631,911  |
9       | 154,95    | 4.2   | 4,285  | 1,900 | 472 | 4,606,302  |
10      | 133,194   | 336   | 5,556  | 1,632 | 406 | 3,953,952  |
11      | 128,724   | 335   | 3,838  | 1,578 | 392 | 3,839,860  |
12      | 152,165   | 335   | 4,277  | 1,864 | 464 | 4,533,680  |



| AWR Metric              |  Last Test|   2       | 3         | 4         | 5     |  6        |  7        |   8       |   9       |   10      | 11 |      12          |
| ----                    | ----      | ------    | ----      | -----     | ----  | ----      | ----      | ----      | ----      | -----     | ---     | ----        | 
| Logical read/s          |  66,991   | 41,735    | 40,755    | 43,214    | NA    | 83,120    | 133,312   | 121,897   | 154,954   | 133,194   | 128,724 | 152,165     |
| Physical read/s         |  1,638    | .8        | 333       |.2         |       | .2        | 325       | .2        | 4.2       | 336       | 335     | 335         |
| Physical write/s        |  9,342    | 5,772     | 5,573     |  4,202    |       | 4,536     | 4,894     | 3,384     | 4,285     | 5,556     | 3,838   | 4,277       |
| Executes/s              |  824      | 511       | 501       | 528       |       | 1,016     | 1,633     | 1,491     | 1,900     | 1,632     |1,578    |  1,864      |
| Transactions/s          |  204      | 127       | 124       | 131       |       | 253       | 407       | 372       | 472       | 406       | 392     | 464         |
| Execs of most exp query*| 1,989,971 | 1,249,562 | 1,224,431 | 1,290,303 |  NA   | 2,471,303 | 3,963,227 | 3,631,911 | 4,606,302 | 3,953,952 | 3,839,860 | 4,533,680 |


*consistent at 65.2 gets/execution     

- IOPS from AWR for this last test: 8035
- 6237

