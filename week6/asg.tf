resource "aws_iam_role" "edu-12-assume-role" {
  name               = "edu-12-assume-role"
  assume_role_policy = file("${path.module}/policies/assumerolepolicy.json")
}

resource "aws_iam_policy" "edu-12-dynamodb-policy" {
  name        = "edu-12-dynamodb-policy"
  description = "dynamodb access policy"
  policy      = file("${path.module}/policies/dynamoDBpolicy.json")
}

resource "aws_iam_policy_attachment" "s3-policy-attach-to-assume-role" {
  name       = "s3policy-attach-to-es2-s3access-role"
  roles      = [aws_iam_role.edu-12-assume-role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_policy_attachment" "dynamodb-policy-attach-to-es2-s3access-role" {
  name       = "dynamodb-policy-attach-to-es2-s3access-role"
  roles      = [aws_iam_role.edu-12-assume-role.name]
  policy_arn = aws_iam_policy.edu-12-dynamodb-policy.arn
}

resource "aws_iam_policy_attachment" "sqs-policy-attach-to-assume-role" {
  name       = "sqs-policy-attach-to-assume-role"
  roles      = [aws_iam_role.edu-12-assume-role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonSQSFullAccess"
}

resource "aws_iam_policy_attachment" "sns-policy-attach-to-assume-role" {
  name       = "sns-policy-attach-to-assume-role"
  roles      = [aws_iam_role.edu-12-assume-role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonSNSFullAccess"
}

resource "aws_iam_instance_profile" "edu-12-instance-profile" {
  name = "edu-12-instance-profile"
  role = aws_iam_role.edu-12-assume-role.name
}

resource "aws_launch_template" "asg-launch-template" {
  name                                 = "my-asg-launch-template"
  image_id                             = var.ami_id
  instance_initiated_shutdown_behavior = "terminate"
  instance_type                        = var.instance_type
  key_name                             = var.key_name
  //vpc_security_group_ids               = [aws_security_group.edu-12-ssh-sg-public.id, aws_security_group.edu-12-web-sg-public.id]
  user_data                            = filebase64("${path.module}/scripts/download.sh")
  iam_instance_profile {
    arn = aws_iam_instance_profile.edu-12-instance-profile.arn
  }
  network_interfaces {
    associate_public_ip_address = true
    security_groups = [aws_security_group.edu-12-ssh-sg-public.id, aws_security_group.edu-12-web-sg-public.id]
  }
}

resource "aws_autoscaling_group" "edu-12-asg" {
  launch_template {
    id      = aws_launch_template.asg-launch-template.id
    version = "$Latest"
  }
  vpc_zone_identifier = flatten(module.vpc.public_subnet_ids)
  min_size            = 2
  max_size            = 2
  desired_capacity    = 2
  load_balancers      = [aws_elb.edu-12-elb.name]
  health_check_type   = "ELB"
  tag {
    key                 = "Name"
    value               = "sdu-12-asg"
    propagate_at_launch = true
  }
}
