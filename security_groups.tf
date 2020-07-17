# Security groups and rules definitions


#Security group for bastion access
#Ideally only ssh (22) traffic needs to be allowed ingress
resource "aws_security_group" "bastion_sg" {
  name        = "wordpress_bastion_sg"
  description = "Allow external networks to access internal resouces of VPC via SSH"
  vpc_id      = aws_vpc.wordpress-vpc.id
  tags        = var.tags
}

#Security group rules for bastion sg
resource "aws_security_group_rule" "allow_bastion_incoming_ssh" {
  type              = "ingress"
  description       = "Allow SSH access into bastion hosts"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = var.allowed_ip_list
  security_group_id = aws_security_group.bastion_sg.id
}
resource "aws_security_group_rule" "allow_bastion_incoming_all" {
  #This rule is for development access
  type              = "ingress"
  description       = "Allow all access into bastion hosts"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = var.allowed_ip_list
  security_group_id = aws_security_group.bastion_sg.id
}
resource "aws_security_group_rule" "allow_bastion_internal_all" {
  #This rule is for development access
  type                     = "ingress"
  description              = "Allow all access internally in bastion hosts"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = aws_security_group.bastion_sg.id
  security_group_id        = aws_security_group.bastion_sg.id
}
resource "aws_security_group_rule" "allow_all_bastion_egress" {
  type              = "egress"
  description       = "Allow all egress traffic from bastion"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.bastion_sg.id
}
