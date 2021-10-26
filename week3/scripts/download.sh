#!/bin/bash
amazon-linux-extras install postgresql13 -y
aws s3 cp s3://edno-23412-f/dynamodb-script.sh /home/ec2-user/dynamodb-script.sh
aws s3 cp s3://edno-23412-f/rds-script.sql /home/ec2-user/rds-script.sql
sudo chmod +x dynamodb-script.sh
sudo chmod +x rds-script.sql
aws configure set default.region us-west-2
