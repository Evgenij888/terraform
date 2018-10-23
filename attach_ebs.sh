#!/bin/bash

while [ ! -e "/dev/xvdb" ]; do sleep 1; done
sudo mkfs.ext4 -F /dev/xvdb
sudo mkdir /data
sudo mount /dev/xvdb /data
echo /dev/xvdb  /data ext4 defaults,nofail 0 2 >> /etc/fstab
