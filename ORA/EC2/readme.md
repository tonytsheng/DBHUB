/etc/oratab

/etc/init.d/dbora

[root@ip-10-0-19-32 etc]# ls -l rc*/*ora*
lrwxrwxrwx 1 root root 15 Sep 11 13:57 rc0.d/K10dbora -> ../init.d/dbora
lrwxrwxrwx 1 root root 15 Sep 11 13:57 rc1.d/K10dbora -> ../init.d/dbora
lrwxrwxrwx 1 root root 15 Sep 11 13:57 rc2.d/K10dbora -> ../init.d/dbora
lrwxrwxrwx 1 root root 15 Sep 11 13:58 rc3.d/S99dbora -> ../init.d/dbora
lrwxrwxrwx 1 root root 15 Sep 11 13:58 rc4.d/S99dbora -> ../init.d/dbora
lrwxrwxrwx 1 root root 15 Sep 11 13:58 rc5.d/S99dbora -> ../init.d/dbora
lrwxrwxrwx 1 root root 15 Sep 11 13:59 rc6.d/K10dbora -> ../init.d/dbora

## instance store
[ec2-user@ip-10-0-30-84 ~]$ df -h
Filesystem      Size  Used Avail Use% Mounted on
devtmpfs        7.6G     0  7.6G   0% /dev
tmpfs           7.6G     0  7.6G   0% /dev/shm
tmpfs           7.6G   17M  7.6G   1% /run
tmpfs           7.6G     0  7.6G   0% /sys/fs/cgroup
/dev/nvme2n1p1  100G  1.8G   99G   2% /
/dev/nvme0n1p1  493G  250G  218G  54% /u01
tmpfs           1.6G     0  1.6G   0% /run/user/54321
tmpfs           1.6G     0  1.6G   0% /run/user/1000

[ec2-user@ip-10-0-30-84 ~]$ lsblk
NAME        MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
nvme0n1     259:0    0  500G  0 disk
└─nvme0n1p1 259:2    0  500G  0 part /u01
nvme2n1     259:3    0  100G  0 disk
└─nvme2n1p1 259:4    0  100G  0 part /
nvme1n1     259:1    0  1.1T  0 disk

[ec2-user@ip-10-0-30-84 ~]$ ls -l /dev/disk/by-uuid/
total 0
lrwxrwxrwx 1 root root 15 Sep 11 17:29 7e3ca95e-231c-4753-9b99-81a35b7875cc -> ../../nvme2n1p1
lrwxrwxrwx 1 root root 15 Sep 11 17:29 f9be8852-a596-4d2d-a1fa-097e4ad8022c -> ../../nvme0n1p1

[ec2-user@ip-10-0-30-84 ~]$ sudo mkfs -t xfs /dev/nvme1n1
meta-data=/dev/nvme1n1           isize=256    agcount=4, agsize=76293946 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=0        finobt=0, sparse=0
data     =                       bsize=4096   blocks=305175781, imaxpct=5
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
log      =internal log           bsize=4096   blocks=149011, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

[ec2-user@ip-10-0-30-84 ~]$ lsblk
NAME        MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
nvme0n1     259:0    0  500G  0 disk
└─nvme0n1p1 259:2    0  500G  0 part /u01
nvme2n1     259:3    0  100G  0 disk
└─nvme2n1p1 259:4    0  100G  0 part /
nvme1n1     259:1    0  1.1T  0 disk

[ec2-user@ip-10-0-30-84 ~]$ sudo mkdir /fast

[ec2-user@ip-10-0-30-84 ~]$ sudo mount /dev/nvme1n1 /fast

[ec2-user@ip-10-0-30-84 ~]$ df -h
Filesystem      Size  Used Avail Use% Mounted on
devtmpfs        7.6G     0  7.6G   0% /dev
tmpfs           7.6G     0  7.6G   0% /dev/shm
tmpfs           7.6G   17M  7.6G   1% /run
tmpfs           7.6G     0  7.6G   0% /sys/fs/cgroup
/dev/nvme2n1p1  100G  1.8G   99G   2% /
/dev/nvme0n1p1  493G  250G  218G  54% /u01
tmpfs           1.6G     0  1.6G   0% /run/user/54321
tmpfs           1.6G     0  1.6G   0% /run/user/1000
/dev/nvme1n1    1.2T   33M  1.2T   1% /fast

