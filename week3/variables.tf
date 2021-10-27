variable "ami_id" {
  type    = string
  default = "ami-0c2d06d50ce30b442"
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
