#### commands
_from repo root_
deploy CloudFormation stack
```
> aws cloudformation deploy --template-file ./week/week1.yaml --stack-name my-week1-stack
```

connect to the instance via ssh:
```
> ssh -i ./mac_key_banana-user.pem ec2-user@[paste_es2_instance_ip_here]
```

destroy CloudFormation stack
```
> aws cloudformation delete-stack --stack-name my-week1-stack
```