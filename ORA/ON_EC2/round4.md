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


| AWR Metric       |  Last Test |   2 | 3      | 4      | 5      |  6    |  7      |
| ----             | ----    | ------ | ----   | -----  | ------ | ----  | ----    |
| Logical read/s   |  66,991 | 41,735 | 40,755 | 43,214 | NA     | 83,120| 133,312 |
| Physical read/s  |  1,638  | .8     | 333    |.2      |        | .2    | 325     |
| Physical write/s |  9,342  | 5,772  | 5,573  |  4,202 |        | 4,536 | 4,894   |
| Executes/s       |  824    | 511    | 501    | 528    |        | 1,016 | 1,633   |
| Transactions/s   |  204    | 127    | 124    | 131    |        | 253   | 407     |
| Execs of most exp query |    1,989,971 | 1,249,562 | 1,224,431 | 1,290,303 |  NA       | 2,471,303 | 3,963,227 |       



*consistent at 65.2 gets/execution     

- IOPS from AWR for this last test: 8035
- 6237

