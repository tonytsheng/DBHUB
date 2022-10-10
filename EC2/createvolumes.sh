#!/bin/bash

clear

# Run lsblk to get the local NVME devices
sudo pvcreate /dev/nvme2n1
sudo pvcreate /dev/nvme3n1
sudo pvcreate /dev/nvme4n1
sudo pvcreate /dev/nvme5n1

sudo vgcreate vg_data /dev/nvme2n1
sudo vgextend vg_data /dev/nvme3n1
sudo vgextend vg_data /dev/nvme4n1
sudo vgextend vg_data /dev/nvme5n1

sudo lvcreate -L 5T -i 4 -I 512k -n lv_data vg_data

sudo mkdir /data

sudo mkfs -t xfs /dev/vg_data/lv_data

sudo mount /dev/vg_data/lv_data /data

sudo chown -R ec2-user /data
sudo chgrp -R ec2-user /data

