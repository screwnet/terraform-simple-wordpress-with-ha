resource "aws_route_table" "simple_webserver_public-rt" {
  vpc_id = aws_vpc.simple_webserver_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.simple_webserver_igw.id
  }
  tags = var.tags
}

resource "aws_route_table_association" "simple_webserver_public-rta1" {
  # Associates RTB to public subnet 10.0.1.0/24
  subnet_id      = aws_subnet.simple_webserver_public-az1.id
  route_table_id = aws_route_table.simple_webserver_public-rt.id
}

resource "aws_route_table_association" "simple_webserver_public-rta2" {
  # Associates RTB to public subnet 10.0.1.0/24
  subnet_id      = aws_subnet.simple_webserver_public-az2.id
  route_table_id = aws_route_table.simple_webserver_public-rt.id
}
