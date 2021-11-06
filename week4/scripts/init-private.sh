#!/bin/bash
sudo su
yum update -y
sudo amazon-linux-extras enable nginx1
yum install nginx -y
service nginx start
chkconfig nginx on
cd /usr/share/nginx/html
echo "Hello from the private side" > index.html