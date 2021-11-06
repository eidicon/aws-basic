resource "aws_security_group" "edu-12-web-sg-private" {
  name = "allow-http-sg-private"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.public_subnet_cidr]
  }
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [var.public_subnet_cidr]
  }
  ingress {
    cidr_blocks = [var.public_subnet_cidr]
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

  vpc_id = aws_vpc.edu-12-vpc.id
  tags = {
    Name = "edu-12-ssh-web-private"
  }
}

resource "aws_instance" "edu-12-private-instace" {
  launch_template {
    id      = aws_launch_template.edu-12-launch-template.id
    version = "$Latest"
  }
  availability_zone      = aws_subnet.edu-12-private-subnet-2b.availability_zone
  vpc_security_group_ids = [aws_security_group.edu-12-web-sg-private.id]
  subnet_id              = aws_subnet.edu-12-private-subnet-2b.id
  user_data              = filebase64("${path.module}/scripts/init-private.sh")

  tags = {
    Name = "edu-12-private-instace"
  }
}
