- ec2 ien24xlarge
- 96 cpus x 768 memory
- oracle sga - 700G
- flash cache across 8 instance store volumes - 200G each - 1600G
- tempfiles - 8 across instance store volumes - 16G each - 128G

- 2. increased log buffer

| AWR Metric           |  Last Test |   2    | 3      | 4      | 5      |  6    |
| ----             | ----    | ------ | ----   | -----  | ------ | ----  |
| Logical read/s   |  66,991 | 41,735 | 40,755 |
| Physical read/s  |  1,638| .8 | 333 |
| Physical write/s |  9,342| 5,772 | 5,573 |
| Executes/s       |  824 | 511 | 501 |
| Transactions/s   |  204 | 127 | 124 |

|                                       |     Last Test  |   2        |  3        | 4      | 5         |  6    |
| -------------                         |  --------  |  ----      | ----      | ----   | -------   | ----  |
|Executions of the most expensive query |   1,989,971 | 1,249,562 | 1,224,431 |
|*consistent at 65.2 gets/execution     |

- IOPS from AWR for this last test: 8035
- 6237

