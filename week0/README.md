#### commands
deploy CloudFormation stack
```
> aws cloudformation deploy --template-file ./simple-ec2.cfn.yaml --stack-name my-week0-stack
```

connetc to the instance via ssh:
```
> ssh -i ../mac_key_banana-user.pem ec2-user@34.219.35.234
```

destroy CloudFormation stack
```
> aws cloudformation delete-stack --stack-name my-week0-stack
```