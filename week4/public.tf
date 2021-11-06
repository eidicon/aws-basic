resource "aws_security_group" "edu-12-web-sg-public" {
  name = "allow-http-sg-public"
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
  vpc_id = aws_vpc.edu-12-vpc.id
  tags = {
    Name = "edu-12-ssh-web-public"
  }
}

resource "aws_security_group" "edu-12-ssh-sg-public" {
  name = "allow-ssh-sg"
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  vpc_id = aws_vpc.edu-12-vpc.id
  tags = {
    Name = "edu-12-ssh-sg-public"
  }
}

resource "aws_instance" "edu-12-public-instace" {
  launch_template {
    id      = aws_launch_template.edu-12-launch-template.id
    version = "$Latest"
  }
  availability_zone           = aws_subnet.edu-12-public-subnet-2a.availability_zone
  vpc_security_group_ids      = [aws_security_group.edu-12-web-sg-public.id, aws_security_group.edu-12-ssh-sg-public.id]
  subnet_id                   = aws_subnet.edu-12-public-subnet-2a.id
  associate_public_ip_address = true
  user_data                   = filebase64("${path.module}/scripts/init-public.sh")

  tags = {
    Name = "edu-12-public-instace"
  }
}
