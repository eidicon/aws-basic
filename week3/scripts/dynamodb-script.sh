#!/bin/bash -xe
aws dynamodb put-item \
    --table-name cloudProviders  \
    --item \
        '{"providerId": {"S": "001"}, "providerName": {"S": "aws"}}'

aws dynamodb put-item \
    --table-name cloudProviders  \
    --item \
        '{"providerId": {"S": "002"}, "providerName": {"S": "azure"}}'

aws dynamodb put-item \
    --table-name cloudProviders  \
    --item \
        '{"providerId": {"S": "003"}, "providerName": {"S": "gcp"}}'

aws dynamodb scan --table-name cloudProviders       