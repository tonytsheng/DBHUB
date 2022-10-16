- Data
  - /u02 
  - /u03

- Flash Cache - 40G
  - /fast01

- TEMP tablespace
  - /fast01

- only 1 instance store volume available so bump up flash cache size to 40G
- put the temp tablespace on an instance store volume

| AWR Metric           |  Last Test |   2    | 3      | 4      | 5      |  6    |
| ----             | ----    | ------ | ----   | -----  | ------ | ----  |
| Logical read/s   |  63,229 | 66,991 |
| Physical read/s  |  1,697 | 1,638|
| Physical write/s |  10,244 | 9,342|
| Executes/s       |  771 | 824 |
| Transactions/s   |  193 | 204 |

  |
| -------------                         |  --------  |  ----      | ----      | ----   | -------   | ----  |
|Executions of the most expensive query |   1,687,701 | 1,989,971
|*consistent at 65.2 gets/execution     |

- IOPS from AWR for this last test: 8035

