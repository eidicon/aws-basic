### list of the commands
upload file
```> ./scripts/init-s3.sh```

check the syntax
```> terraform plan -var-file="secret.tfvars"```

deploy plan
```> terraform apply -var-file="secret.tfvars"```

remove deployed
```> terraform destroy -var-file="secret.tfvars"```

### remove bucket
aws s3 rb s3://edno-23412-f --force  // should be applied script to "clear" bucket first

### run sql script
```
> psql -U [dbuser] -h [dbhost] -p 5432 -f ./rds-script.sql -d postgres -f ./rds-script.sql
```