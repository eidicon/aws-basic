#!/bin/bash -xe
touch file.txt && echo "this is a line" > file.txt
aws s3api create-bucket --bucket edno-23412-f --region us-west-2 --create-bucket-configuration LocationConstraint=us-west-2
aws s3api put-bucket-versioning --bucket edno-23412-f --versioning-configuration Status=Enabled
aws s3 cp ./file.txt s3://edno-23412-f
