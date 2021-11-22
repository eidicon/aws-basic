variable "region" {
  type    = string
  default = "us-west-2"
}

variable "nat_ami" {
  type    = string
  default = "ami-0032ea5ae08aa27a2"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "ami_id" {
  type    = string
  default = "ami-0c2d06d50ce30b442"
}

variable "key_name" {
  type    = string
  default = "mac_key_banana-user"
}

variable "lb_check_path" {
  type    = string
  default = "/actuator/health"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  type    = list
  default = ["10.0.1.0/24", "10.0.3.0/24"]
}
variable "public_subnet_az" {
  type    = list
  default = ["us-west-2a", "us-west-2b"]
}

variable "public_subnet_names" {
  type    = list
  default = ["edu-12-pubic-subnet-1", "edu-12-pubic-subnet-2"]
}

variable "private_subnet_cidr" {
  type    = list
  default = ["10.0.2.0/24","10.0.4.0/24"]
}

variable "private_subnet_az" {
  type    = list
  default = ["us-west-2c", "us-west-2d"]
}

variable "private_subnet_names" {
  type    = list
  default = ["edu-12-private-subnet-1", "edu-12-private-subnet-2"]
}

variable "dynamo_db_name" {
  type = string
  default = "edu-lohika-training-aws-dynamodb"
}

variable "rds_name" {
  type = string
  default = "EduLohikaTrainingAwsRds"
}

variable "db_username" {
  description = "Database administrator username"
  type        = string
  sensitive   = true
}
variable "db_password" {
  description = "Database administrator password"
  type        = string
  sensitive   = true
}

variable "sqs_name" {
  type = string
  default = "edu-lohika-training-aws-sqs-queue"
} 

variable "sns_topic" {
  type = string
  default = "edu-lohika-training-aws-sns-topic"
}

variable "account_id" {
  description = "aws account id"
  type        = string
  sensitive   = true
}