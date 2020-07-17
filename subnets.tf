#This file defines all subnets involved in this VPC
# Subnet for placing resources
resource "aws_subnet" "bastion_subnet1" {
  vpc_id                  = aws_vpc.wordpress-vpc.id
  cidr_block              = var.bastion_sn_az1
  availability_zone       = data.aws_availability_zones.az.names[0]
  map_public_ip_on_launch = true
  tags                    = var.tags
}
resource "aws_subnet" "bastion_subnet2" {
  vpc_id                  = aws_vpc.wordpress-vpc.id
  cidr_block              = var.bastion_sn_az2
  availability_zone       = data.aws_availability_zones.az.names[1]
  map_public_ip_on_launch = true
  tags                    = var.tags
}
