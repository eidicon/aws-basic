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

resource "aws_vpc" "edu-12-vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = "edu-12-vpc"
  }
}

resource "aws_internet_gateway" "edu-12-gateway" {
  vpc_id = aws_vpc.edu-12-vpc.id
  tags = {
    Name = "edu-12-gateway"
  }
}

# Public subnet 
resource "aws_subnet" "edu-12-public-subnet-2a" {
  vpc_id            = aws_vpc.edu-12-vpc.id
  cidr_block        = var.public_subnet_cidr
  availability_zone = "us-west-2a"

  tags = {
    Name = "edu-12-public-subnet-2a"
  }
}

resource "aws_route_table" "edu-12-public-subnet-2a" {
  vpc_id = aws_vpc.edu-12-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.edu-12-gateway.id
  }

  tags = {
    Name = "edu-12-public-subnet-2a"
  }
}

resource "aws_route_table_association" "edu-12-public-subnet-2a" {
  subnet_id      = aws_subnet.edu-12-public-subnet-2a.id
  route_table_id = aws_route_table.edu-12-public-subnet-2a.id
}


#Private subnet
resource "aws_subnet" "edu-12-private-subnet-2b" {
  vpc_id            = aws_vpc.edu-12-vpc.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = "us-west-2b"

  tags = {
    Name = "edu-12-private-subnet-2b"
  }
}

resource "aws_route_table" "edu-12-private-subnet-2b" {
  vpc_id = aws_vpc.edu-12-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    instance_id = aws_instance.edu-12-nat.id
  }

  tags = {
    Name = "edu-12-private-subnet-2b"
  }
}

resource "aws_route_table_association" "edu-12-private-subnet-2b" {
  subnet_id      = aws_subnet.edu-12-private-subnet-2b.id
  route_table_id = aws_route_table.edu-12-private-subnet-2b.id
}

resource "aws_iam_role" "ec2_s3_access_role" {
  name               = "custom-access-role"
  assume_role_policy = file("${path.module}/policies/assumerolepolicy.json")
}

resource "aws_iam_instance_profile" "role-instance-profile" {
  name = "instance-access-s3-profile"
  role = aws_iam_role.ec2_s3_access_role.name
}

resource "aws_launch_template" "edu-12-launch-template" {
  name                                 = "edu-12-launch-template"
  image_id                             = var.ami_id
  instance_initiated_shutdown_behavior = "terminate"
  instance_type                        = var.instance_type
  key_name                             = var.key_name

  iam_instance_profile {
    arn = aws_iam_instance_profile.role-instance-profile.arn
  }
}

resource "aws_lb_target_group" "edu-12-lb-tg" {
  name     = "edu-12-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.edu-12-vpc.id
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    path                = "/index.html"
    interval            = 30
    port                = 80
    matcher             = "200"
  }

  tags = {
    Name = "edu-12-lb-tg"
  }
}

resource "aws_lb_target_group_attachment" "edu-12-lb-tg-public" {
  target_group_arn = aws_lb_target_group.edu-12-lb-tg.arn
  target_id        = aws_instance.edu-12-public-instace.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "edu-12-lb-tg-private" {
  target_group_arn = aws_lb_target_group.edu-12-lb-tg.arn
  target_id        = aws_instance.edu-12-private-instace.id
  port             = 80
}

resource "aws_lb_listener" "edu-12-lb-listener" {
  load_balancer_arn = aws_lb.edu-12-lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.edu-12-lb-tg.arn
    type             = "forward"
  }
}

resource "aws_lb" "edu-12-lb" {
  name    = "edu-12-lb"
  subnets = [aws_subnet.edu-12-public-subnet-2a.id, aws_subnet.edu-12-private-subnet-2b.id]
  security_groups = [aws_security_group.edu-12-web-sg-public.id]

  tags = {
    Name = "edu-12-lb"
  }
}
