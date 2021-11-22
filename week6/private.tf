resource "aws_security_group" "edu-12-web-sg-private" {
  name = "allow-http-sg-private"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.public_subnet_cidr
  }
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = var.public_subnet_cidr
  }
  ingress {
    cidr_blocks = var.public_subnet_cidr
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

  vpc_id = module.vpc.vpc_id
  tags = {
    Name = "edu-12-ssh-web-private"
  }
}

resource "aws_security_group" "rds-pg-sg" {
  name = "allow-rds-pg-sg"
  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.edu-12-web-sg-private.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = module.vpc.vpc_id
  tags = {
    Name = "edu-12-ssh-web-private"
  }
}

resource "aws_instance" "edu-12-private-instace" {
  instance_initiated_shutdown_behavior = "terminate"
  ami                                  = var.ami_id
  instance_type                        = var.instance_type
  key_name                             = var.key_name
  availability_zone                    = flatten(module.vpc.private_subnet_azs)[0]
  vpc_security_group_ids               = [aws_security_group.edu-12-web-sg-private.id]
  subnet_id                            = flatten(module.vpc.private_subnet_ids)[0]
  user_data                            = <<EOF
  #!/bin/bash
  yum -y install java-1.8.0-openjdk
  amazon-linux-extras install postgresql13 -y
  aws s3 cp s3://edno-23412-f/persist3-0.0.1-SNAPSHOT.jar /home/ec2-user/persist3-0.0.1-SNAPSHOT.jar
  sudo /sbin/sysctl -w net.ipv4.ip_unprivileged_port_start=0
  echo export RDS_HOST=${aws_db_instance.edu-12.address} >> /etc/profile
  java -jar /home/ec2-user/persist3-0.0.1-SNAPSHOT.jar &
  EOF

  tags = {
    Name = "edu-12-private-instace"
  }
  depends_on = [
    aws_instance.edu-12-nat,
    aws_db_instance.edu-12
  ]
  iam_instance_profile = aws_iam_instance_profile.edu-12-private-instance-profile.name
}

resource "aws_db_parameter_group" "edu-12" {
  name   = "education"
  family = "postgres13"
  parameter {
    name  = "log_connections"
    value = "1"
  }
}

resource "aws_db_subnet_group" "edu-12-db-subnet-group" {
  name       = "edu-12-db-subnet-group"
  subnet_ids = flatten(module.vpc.private_subnet_ids)
}

resource "aws_db_instance" "edu-12" {
  name                   = var.rds_name
  identifier             = "education"
  allocated_storage      = 5
  engine                 = "postgres"
  engine_version         = "13.1"
  instance_class         = "db.t3.micro"
  username               = var.db_username
  password               = var.db_password
  parameter_group_name   = aws_db_parameter_group.edu-12.name
  skip_final_snapshot    = true
  publicly_accessible    = false
  vpc_security_group_ids = [aws_security_group.edu-12-web-sg-private.id, aws_security_group.rds-pg-sg.id]
  db_subnet_group_name   = aws_db_subnet_group.edu-12-db-subnet-group.id
}

resource "aws_iam_role" "edu-12-private-access-role" {
  name               = "edu-12-private-access-role"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

resource "aws_iam_instance_profile" "edu-12-private-instance-profile" {
  name = "edu-12-private-access-profile"
  role = aws_iam_role.edu-12-private-access-role.name
}

resource "aws_iam_role_policy" "edu-12-private-policy" {
  name = "edu-12-private-policy"
  role = aws_iam_role.edu-12-private-access-role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:*",
          "rds:*",
          "sns:*",
          "s3:*"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}
