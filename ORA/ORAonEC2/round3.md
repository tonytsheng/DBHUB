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
| Logical read/s   |  63,229 |
| Physical read/s  |  1,697 |
| Physical write/s |  10,244 |
| Executes/s       |  771 |
| Transactions/s   |  193 |

