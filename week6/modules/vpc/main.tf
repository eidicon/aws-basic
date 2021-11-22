resource "aws_vpc" "edu-12-vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = "edu-12-vpc"
  }
}

# Internet gateway
resource "aws_internet_gateway" "edu-12-gateway" {
  vpc_id = aws_vpc.edu-12-vpc.id
  tags = {
    Name = "edu-12-gateway"
  }
}

# Public subnet 
resource "aws_subnet" "edu-12-public-subnets" {
  count             = length(var.public_subnet_cidr)
  vpc_id            = aws_vpc.edu-12-vpc.id
  cidr_block        = element(var.public_subnet_cidr, count.index)
  availability_zone = element(var.public_subnet_az, count.index)

  tags = {
    Name = "edu-12-public-subnets"
  }
}

resource "aws_route_table" "edu-12-public-subnets-rt" {
  vpc_id = aws_vpc.edu-12-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.edu-12-gateway.id
  }

  tags = {
    Name = "edu-12-public-subnets-rt"
  }
}

resource "aws_route_table_association" "edu-12-public-subnets" {
  count          = length(var.private_subnet_cidr)
  subnet_id      = element(aws_subnet.edu-12-public-subnets.*.id, count.index)
  route_table_id = aws_route_table.edu-12-public-subnets-rt.id
}


#Private subnets
resource "aws_subnet" "edu-12-private-subnets" {
  count             = length(var.private_subnet_cidr)
  vpc_id            = aws_vpc.edu-12-vpc.id
  cidr_block        = element(var.private_subnet_cidr, count.index)
  availability_zone = element(var.private_subnet_az, count.index)

  tags = {
    Name = "edu-12-private-subnets"
  }
}

resource "aws_route_table" "edu-12-private-subnets-rt" {
  vpc_id = aws_vpc.edu-12-vpc.id

  route {
    cidr_block  = "0.0.0.0/0"
    instance_id = var.nat_instance_id
  }

  tags = {
    Name = "edu-12-private-subnets-rt"
  }
}

resource "aws_route_table_association" "edu-12-private-subnets" {
  count          = length(var.private_subnet_cidr)
  subnet_id      = element(aws_subnet.edu-12-private-subnets.*.id, count.index)
  route_table_id = aws_route_table.edu-12-private-subnets-rt.id
}
