#!/bin/bash
while [ ! -e "/dev/sda2" ]; do sleep 1; done
if [ "$(sudo file -b -s /dev/sda2)" == "data" ]; then
sudo mkfs -t ext4 /dev/sa2
fi
echo '/dev/sda2 /data ext4 defaults,nofail 0 2' >> /etc/fstab
sudo mkdir /data
sudo mount /dev/sda2 /data
cd /data
git clone git@github.com:Evgenij888/testweb.git
apt-get install php
php -S localhost:80

