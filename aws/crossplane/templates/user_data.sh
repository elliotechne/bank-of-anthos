#!/bin/bash
yum install docker -y 
yum install git -y
service docker start
wget https://github.com/docker/compose/releases/download/v2.5.1/docker-compose-linux-x86_64 && mv docker-compose-linux-x86_64 /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

git clone https://github.com/autotune/django.git
