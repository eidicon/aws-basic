terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = "~> 1.0.4"
}

provider "aws" {
  profile = "default"
  region  = var.region
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_dynamodb_table" "provider-table" {
  name           = var.table_name
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "providerId"
  range_key      = "providerName"
  attribute {
    name = "providerId"
    type = "S"
  }

  attribute {
    name = "providerName"
    type = "S"
  }
}

resource "aws_db_parameter_group" "edu-12" {
  name   = "education"
  family = "postgres13"
  parameter {
    name  = "log_connections"
    value = "1"
  }
}
resource "aws_db_instance" "edu-12" {
  identifier             = "education"
  allocated_storage      = 5
  engine                 = "postgres"
  engine_version         = "13.1"
  instance_class         = "db.t3.micro"
  username               = var.db_username
  password               = var.db_password
  parameter_group_name   = aws_db_parameter_group.edu-12.name
  skip_final_snapshot    = true
  publicly_accessible    = true
  vpc_security_group_ids = [aws_security_group.rds-pg-sg.id]
}

resource "aws_security_group" "ssh-sg" {
  name = "allow-ssh-sg"
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "web-sg" {
  name = "allow-http-sg"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "rds-pg-sg" {
  name = "allow-rds-pg-sg"
  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.web-sg.id, aws_security_group.ssh-sg.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_iam_role" "ec2_s3_access_role" {
  name               = "custom-access-role"
  assume_role_policy = file("${path.module}/policies/assumerolepolicy.json")
}

resource "aws_iam_policy" "custom-access-policy" {
  name        = "custom-access-policy"
  description = "A test policy"
  policy      = file("${path.module}/policies/custom-access-policy.json")
}

resource "aws_iam_policy_attachment" "s3policy-attach-to-es2-s3access-role" {
  name       = "s3policy-attach-to-es2-s3access-role"
  roles      = ["${aws_iam_role.ec2_s3_access_role.name}"]
  policy_arn = aws_iam_policy.custom-access-policy.arn
}

resource "aws_iam_instance_profile" "role-instance-profile" {
  name = "instance-access-s3-profile"
  role = aws_iam_role.ec2_s3_access_role.name
}

resource "aws_launch_template" "asg-launch-template" {
  name                                 = "my-asg-launch-template"
  image_id                             = var.ami_id
  instance_initiated_shutdown_behavior = "terminate"
  instance_type                        = var.instance_type
  key_name                             = var.key_name
  vpc_security_group_ids               = [aws_security_group.web-sg.id, aws_security_group.ssh-sg.id, aws_security_group.rds-pg-sg.id]
  user_data                            = filebase64("${path.module}/scripts/download.sh")
  iam_instance_profile {
    arn = aws_iam_instance_profile.role-instance-profile.arn
  }
}

resource "aws_autoscaling_group" "my-asg" {
  availability_zones = data.aws_availability_zones.available.names
  desired_capacity   = 2
  max_size           = 2
  min_size           = 2

  launch_template {
    id      = aws_launch_template.asg-launch-template.id
    version = "$Latest"
  }
}
