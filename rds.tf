#RDS instance configuration

resource "aws_db_instance" "wordpressdb" {
  allocated_storage               = 20
  max_allocated_storage           = 100
  storage_type                    = "gp2"
  engine                          = "mariadb"
  engine_version                  = "10.2"
  instance_class                  = "db.t2.micro"
  name                            = var.dbname
  identifier                      = "wordpressdb"
  username                        = var.dbuser
  password                        = random_password.dbpass.result
  parameter_group_name            = "default.mariadb10.2"
  availability_zone               = data.aws_availability_zones.az.names[0]
  backup_window                   = "10:30-11:00"
  db_subnet_group_name            = aws_db_subnet_group.wordpressdb_sng.id
  enabled_cloudwatch_logs_exports = ["audit", "error", "general", "slowquery"]
  vpc_security_group_ids          = [aws_security_group.bastion_sg.id]
  monitoring_interval             = 0
  backup_retention_period         = 35
  skip_final_snapshot             = true
  copy_tags_to_snapshot           = true
  allow_major_version_upgrade     = true
  auto_minor_version_upgrade      = true
  apply_immediately               = true
  performance_insights_enabled    = false
  publicly_accessible             = false
  delete_automated_backups        = true
  port                            = 3306
  tags                            = var.tags
}

resource "aws_db_subnet_group" "wordpressdb_sng" {
  name       = "wordpress_db_sn_group"
  subnet_ids = [aws_subnet.bastion_subnet1.id, aws_subnet.bastion_subnet2.id]
  tags       = var.tags
}
