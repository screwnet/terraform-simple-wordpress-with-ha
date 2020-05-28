data "aws_availability_zones" "az" {}
resource "aws_vpc" "simple_webserver_vpc" {
  cidr_block           = var.vpc_cidr_block
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = var.tags
}

# IGW for internet
resource "aws_internet_gateway" "simple_webserver_igw" {
  vpc_id = aws_vpc.simple_webserver_vpc.id
  tags   = var.tags
}

# NAT gateway reuires an EIP -- ESSENTIAL
resource "aws_eip" "priv_eip-az1" {
  vpc        = true
  depends_on = [aws_internet_gateway.simple_webserver_igw]
  tags       = var.tags
}

# NAT gateway for AZ1
resource "aws_nat_gateway" "simple_webserver_ngw-az1" {
  allocation_id = aws_eip.priv_eip-az1.id
  subnet_id     = aws_subnet.simple_webserver_public-az1.id
  tags          = var.tags
}

resource "aws_subnet" "simple_webserver_public-az1" {
  vpc_id                  = aws_vpc.simple_webserver_vpc.id
  cidr_block              = var.public-sn-az1
  availability_zone       = data.aws_availability_zones.az.names[1]
  map_public_ip_on_launch = true
  tags                    = var.tags
  # count      = length(data.aws_availability_zones.available.names)
  # availability_zone       = data.aws_availability_zones.available.names[count.index]
}

resource "aws_subnet" "simple_webserver_private-app-az1" {
  vpc_id                  = aws_vpc.simple_webserver_vpc.id
  cidr_block              = var.private-sn-app-az1
  availability_zone       = data.aws_availability_zones.az.names[1]
  map_public_ip_on_launch = true
  tags                    = var.tags
}

resource "aws_subnet" "simple_webserver_private-db-az1" {
  vpc_id                  = aws_vpc.simple_webserver_vpc.id
  cidr_block              = var.private-sn-db-az1
  availability_zone       = data.aws_availability_zones.az.names[1]
  map_public_ip_on_launch = true
  tags                    = var.tags
}

resource "aws_eip" "priv_eip-az2" {
  vpc        = true
  depends_on = [aws_internet_gateway.simple_webserver_igw]
  tags       = var.tags
}

resource "aws_nat_gateway" "simple_webserver_ngw-az2" {
  allocation_id = aws_eip.priv_eip-az2.id
  subnet_id     = aws_subnet.simple_webserver_public-az2.id
  tags          = var.tags
}


resource "aws_subnet" "simple_webserver_public-az2" {
  vpc_id                  = aws_vpc.simple_webserver_vpc.id
  cidr_block              = var.public-sn-az2
  availability_zone       = data.aws_availability_zones.az.names[2]
  map_public_ip_on_launch = true
  tags                    = var.tags
  # count      = length(data.aws_availability_zones.available.names)
  # availability_zone       = data.aws_availability_zones.available.names[count.index]
}

resource "aws_subnet" "simple_webserver_private-app-az2" {
  vpc_id                  = aws_vpc.simple_webserver_vpc.id
  cidr_block              = var.private-sn-app-az2
  availability_zone       = data.aws_availability_zones.az.names[2]
  map_public_ip_on_launch = true
  tags                    = var.tags
}

resource "aws_subnet" "simple_webserver_private-db-az2" {
  vpc_id                  = aws_vpc.simple_webserver_vpc.id
  cidr_block              = var.private-sn-db-az2
  availability_zone       = data.aws_availability_zones.az.names[2]
  map_public_ip_on_launch = true
  tags                    = var.tags
}
