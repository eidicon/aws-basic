output "vpc_id" {
  value = aws_vpc.edu-12-vpc.id
}

output "public_subnet_ids" {
  value = aws_subnet.edu-12-public-subnets[*].id
}

output "public_subnet_azs" {
  value = aws_subnet.edu-12-public-subnets[*].availability_zone
}


output "private_subnet_ids" {
  value = aws_subnet.edu-12-private-subnets[*].id
}
output "private_subnet_azs" {
  value = aws_subnet.edu-12-private-subnets[*].availability_zone
}

output "internet_gateway_id" {
  value = aws_internet_gateway.edu-12-gateway.id
}
