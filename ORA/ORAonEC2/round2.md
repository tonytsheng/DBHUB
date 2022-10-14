## Round 2
- Create 2 EBS volumes within the Console
  - 900G
  - 45000 IOPS
  - IO1 type
  - Create this in the same availability zone that your EC2 instance is running in.
- When they have been created, click on each one and in the Actions dropdown, Attach to your instnace.
  - They will get attached to a filepath like /dev/sdf
- Create the filesystem
```
[ec2-user@ip-10-0-30-84 fast]$ lsblk
NAME        MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
nvme0n1     259:0    0  900G  0 disk
└─nvme0n1p1 259:1    0  500G  0 part /u01
nvme3n1     259:5    0  900G  0 disk
nvme2n1     259:3    0  100G  0 disk
└─nvme2n1p1 259:4    0  100G  0 part /
nvme1n1     259:2    0  1.1T  0 disk /fast
nvme4n1     259:6    0  900G  0 disk
[ec2-user@ip-10-0-30-84 fast]$
[ec2-user@ip-10-0-30-84 fast]$
[ec2-user@ip-10-0-30-84 fast]$
[ec2-user@ip-10-0-30-84 fast]$ sudo mkfs -t xfs /dev/nvme3n1
meta-data=/dev/nvme3n1           isize=256    agcount=4, agsize=58982400 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=0        finobt=0, sparse=0
data     =                       bsize=4096   blocks=235929600, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
log      =internal log           bsize=4096   blocks=115200, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
[ec2-user@ip-10-0-30-84 fast]$ lsblk
NAME        MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
nvme0n1     259:0    0  900G  0 disk
└─nvme0n1p1 259:1    0  500G  0 part /u01
nvme3n1     259:5    0  900G  0 disk
nvme2n1     259:3    0  100G  0 disk
└─nvme2n1p1 259:4    0  100G  0 part /
nvme1n1     259:2    0  1.1T  0 disk /fast
nvme4n1     259:6    0  900G  0 disk
[ec2-user@ip-10-0-30-84 fast]$ sudo mkdir /u02
[ec2-user@ip-10-0-30-84 fast]$ sudo mount /dev/nvme3n1 /u02
[ec2-user@ip-10-0-30-84 fast]$ df -h
Filesystem      Size  Used Avail Use% Mounted on
devtmpfs        7.6G     0  7.6G   0% /dev
tmpfs           7.6G     0  7.6G   0% /dev/shm
tmpfs           7.6G   17M  7.6G   1% /run
tmpfs           7.6G     0  7.6G   0% /sys/fs/cgroup
/dev/nvme2n1p1  100G  2.6G   98G   3% /
/dev/nvme0n1p1  493G  461G  6.8G  99% /u01
tmpfs           1.6G     0  1.6G   0% /run/user/54321
tmpfs           1.6G     0  1.6G   0% /run/user/1000
/dev/nvme1n1    1.2T   29G  1.1T   3% /fast
/dev/nvme3n1    900G   33M  900G   1% /u02
[ec2-user@ip-10-0-30-84 fast]$ lsblk
NAME        MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
nvme0n1     259:0    0  900G  0 disk
└─nvme0n1p1 259:1    0  500G  0 part /u01
nvme3n1     259:5    0  900G  0 disk /u02
nvme2n1     259:3    0  100G  0 disk
└─nvme2n1p1 259:4    0  100G  0 part /
nvme1n1     259:2    0  1.1T  0 disk /fast
nvme4n1     259:6    0  900G  0 disk

[ec2-user@ip-10-0-30-84 fast]$ df -h
Filesystem      Size  Used Avail Use% Mounted on
devtmpfs        7.6G     0  7.6G   0% /dev
tmpfs           7.6G     0  7.6G   0% /dev/shm
tmpfs           7.6G   17M  7.6G   1% /run
tmpfs           7.6G     0  7.6G   0% /sys/fs/cgroup
/dev/nvme2n1p1  100G  2.6G   98G   3% /
/dev/nvme0n1p1  493G  461G  6.8G  99% /u01
tmpfs           1.6G     0  1.6G   0% /run/user/54321
tmpfs           1.6G     0  1.6G   0% /run/user/1000
/dev/nvme1n1    1.2T   29G  1.1T   3% /fast
/dev/nvme3n1    900G   33M  900G   1% /u02
/dev/nvme4n1    900G   33M  900G   1% /u03
[ec2-user@ip-10-0-30-84 fast]$ lsblk
NAME        MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
nvme0n1     259:0    0  900G  0 disk
└─nvme0n1p1 259:1    0  500G  0 part /u01
nvme3n1     259:5    0  900G  0 disk /u02
nvme2n1     259:3    0  100G  0 disk
└─nvme2n1p1 259:4    0  100G  0 part /
nvme1n1     259:2    0  1.1T  0 disk /fast
nvme4n1     259:6    0  900G  0 disk /u03
```
- Drop the old tablespace. Recreate the tablespace with new data files on the new volumes.

- Recreate slob test data using the modified tablespace/data files

- Increase the size of the log files to 2048 M to hold at least 20 minutes
      of redo information.

- Increase - Increase log buffer init parameter - recommended in the last AWR report.

- Increase flash cache size - Oracle recommends 2-3x the size of the SGA.
