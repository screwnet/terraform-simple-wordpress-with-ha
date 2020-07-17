#The route tables and routes are defined here
################################## Route Tables ################################
#Route traffic for internet access
resource "aws_route_table" "wordpress_rt_for_internet" {
  vpc_id = aws_vpc.wordpress-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.wordpress_igw.id
  }
  tags = var.tags
}

############################## Route Table Assoc ###############################
#Associate bastion subnet with route table
resource "aws_route_table_association" "wordpress_bastion_sn1_rta" {
  subnet_id      = aws_subnet.bastion_subnet1.id
  route_table_id = aws_route_table.wordpress_rt_for_internet.id
}
resource "aws_route_table_association" "wordpress_bastion_sn2_rta" {
  subnet_id      = aws_subnet.bastion_subnet2.id
  route_table_id = aws_route_table.wordpress_rt_for_internet.id
}
