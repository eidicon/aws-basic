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
  region = var.region
}

module "vpc" {
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidr   = var.public_subnet_cidr
  public_subnet_az     = var.public_subnet_az
  public_subnet_names  = var.public_subnet_names
  private_subnet_cidr  = var.private_subnet_cidr
  private_subnet_az    = var.private_subnet_az
  private_subnet_names = var.private_subnet_names
  nat_instance_id      = aws_instance.edu-12-nat.id
  source               = "./modules/vpc"
}
