## Testing 3 scenarios for self managed Oracle on an EC2 instance:
1. Baseline performance test using SLOB and Oracle data files on EBS volumes.
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

- SLOB parameters:
  - UPDATE_PCT: 25
  - SCAN_PCT: 10
  - RUN_TIME: 3600
  - WORK_LOOP: 0
  - SCALE: 800M (51200 blocks)
  - WORK_UNIT: 64
  - REDO_STRESS: LITE
  - hot spot off
  - think time off


