resource "aws_security_group" "simple_webserver_web" {
  name        = "simple_webserver_web"
  description = "Allow ssh and web traffic"
  vpc_id      = aws_vpc.simple_webserver_vpc.id
  tags        = var.tags
}
resource "aws_security_group_rule" "allow_ssh_in_web" {
  type              = "ingress"
  description       = "Allow ssh access"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = var.allowed_ip_list
  security_group_id = aws_security_group.simple_webserver_web.id
}
resource "aws_security_group_rule" "allow_all_out_web" {
  type              = "egress"
  description       = "Allow all outgoing traffic"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.simple_webserver_web.id
}

resource "aws_security_group" "simple_webserver_app" {
  name        = "simple_webserver_app"
  description = "Allow ssh and web traffic"
  vpc_id      = aws_vpc.simple_webserver_vpc.id
  tags        = var.tags
}
resource "aws_security_group_rule" "allow_ssh_in-app" {
  type                     = "ingress"
  description              = "Allow ssh access"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.simple_webserver_web.id
  security_group_id        = aws_security_group.simple_webserver_app.id
}
resource "aws_security_group_rule" "allow_db_in-app" {
  type                     = "ingress"
  description              = "Allow mysql/mariadb/aurora access"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.simple_webserver_web.id
  security_group_id        = aws_security_group.simple_webserver_app.id
}
resource "aws_security_group_rule" "allow_efs_in-app" {
  type                     = "ingress"
  description              = "Allow efs access"
  from_port                = 111
  to_port                  = 111
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.simple_webserver_web.id
  security_group_id        = aws_security_group.simple_webserver_app.id
}
resource "aws_security_group_rule" "allow_efs_in2-app" {
  type                     = "ingress"
  description              = "Allow efs access2"
  from_port                = 2049
  to_port                  = 2049
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.simple_webserver_web.id
  security_group_id        = aws_security_group.simple_webserver_app.id
}
resource "aws_security_group_rule" "allow_all_out_app" {
  type              = "egress"
  description       = "Allow all outgoing traffic"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.simple_webserver_app.id
}
