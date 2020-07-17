#Get all availiability zones of the region
data "aws_availability_zones" "az" {}

#Creating VPC
resource "aws_vpc" "wordpress-vpc" {
  cidr_block           = var.vpc_cidr_block
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = var.tags
}

# IGW for external network access
resource "aws_internet_gateway" "wordpress_igw" {
  vpc_id = aws_vpc.wordpress-vpc.id
  tags   = var.tags
}
