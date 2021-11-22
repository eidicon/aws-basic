#!/bin/bash
yum -y install java-1.8.0-openjdk
aws s3 cp s3://edno-23412-f/calc-0.0.2-SNAPSHOT.jar /home/ec2-user/calc-0.0.2-SNAPSHOT.jar
sudo /sbin/sysctl -w net.ipv4.ip_unprivileged_port_start=0
java -jar /home/ec2-user/calc-0.0.2-SNAPSHOT.jar &