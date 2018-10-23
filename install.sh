#!/bin/bash

sudo apt-get update
sudo apt-get install -y mc
sudo apt-get install -y git
sudo apt-get install -y openssh-server
sudo apt-get install -y php
sudo chmod 777 -R /data
ssh-keyscan github.com >> ~/.ssh/known_hosts
yes | git clone https://github.com/Evgenij888/testweb.git /data/web
sleep 5
sudo chmod 555 -R /data
sudo php -S 0.0.0.0:80 -t /data/web &
echo $! >>/tmp/appweb.pid
