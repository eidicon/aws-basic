resource "aws_security_group" "edu-12-nat-sg" { #https://docs.aws.amazon.com/vpc/latest/userguide/VPC_NAT_Instance.html#NATSG
  name = "edu-12-vpc-nat"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.private_subnet_cidr
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.private_subnet_cidr
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.private_subnet_cidr
  }
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = module.vpc.vpc_id

  tags = {
    Name = "edu-12-nat-sg"
  }
}

resource "aws_instance" "edu-12-nat" {
  ami                                  = var.nat_ami
  availability_zone                    = flatten(module.vpc.public_subnet_azs)[0]
  instance_type                        = var.instance_type
  vpc_security_group_ids               = [aws_security_group.edu-12-nat-sg.id]
  subnet_id                            = flatten(module.vpc.public_subnet_ids)[0]
  source_dest_check                    = false
  instance_initiated_shutdown_behavior = "terminate"
  associate_public_ip_address          = true

  tags = {
    Name = "edu-12-nat"
  }
}
