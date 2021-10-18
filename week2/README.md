### list of the commands
upload file
```> ./scripts/init-s3.sh```

check the syntax
```> terraform plan```

save plan
```> terraform plan -out```

deploy plan
```> terraform apply```

remove deployed
```> terraform destroy```

### remove bucket
aws s3 rb s3://edno-23412-f --force  // should be applied script to "clear" bucket first 