#!/bin/bash -xe
#aws s3api create-bucket --bucket edno-23412-f --region us-west-2 --create-bucket-configuration LocationConstraint=us-west-2
#aws s3api put-bucket-versioning --bucket edno-23412-f --versioning-configuration Status=Enabled
aws s3 cp ./scripts/rds-script.sql s3://edno-23412-f
aws s3 cp ./scripts/dynamodb-script.sh s3://edno-23412-f
