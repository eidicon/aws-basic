variable "ami_id" {
  type    = string
  default = "ami-0c2d06d50ce30b442"
}

variable "nat_ami" {
  type    = string
  default = "ami-0032ea5ae08aa27a2"
}
variable "key_name" {
  type    = string
  default = "mac_key_banana-user"
}

variable "region" {
  type    = string
  default = "us-west-2"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "table_name" {
  type    = string
  default = "cloudProviders"
}

variable "vpc_cidr" {
  type = string
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  type    = string
  default = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  type    = string
  default = "10.0.2.0/24"
}
