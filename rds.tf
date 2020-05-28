# RDS mariabdb database for storing Data

resource "aws_db_instance" "wordpressdb" {
  allocated_storage               = 20
  max_allocated_storage           = 100
  storage_type                    = "gp2"
  engine                          = "mariadb"
  engine_version                  = "10.2"
  instance_class                  = "db.t2.micro"
  name                            = "wordpress"
  identifier                      = "wordpressdb"
  username                        = var.dbuser
  password                        = var.dbpass
  parameter_group_name            = "default.mariadb10.2"
  monitoring_interval             = 0 #If >0, a role need to be defined.
  allow_major_version_upgrade     = true
  auto_minor_version_upgrade      = true
  apply_immediately               = true
  availability_zone               = data.aws_availability_zones.az.names[1]
  backup_retention_period         = 35
  backup_window                   = "10:30-11:00"
  copy_tags_to_snapshot           = true
  db_subnet_group_name            = aws_db_subnet_group.wordpressdb_sng.id
  delete_automated_backups        = true
  enabled_cloudwatch_logs_exports = ["audit", "error", "general", "slowquery"]
  skip_final_snapshot             = true
  tags                            = var.tags
  vpc_security_group_ids          = [aws_security_group.simple_webserver_web.id, aws_security_group.simple_webserver_app.id]
  performance_insights_enabled    = false
  publicly_accessible             = false
  port                            = 3306
}

resource "aws_db_subnet_group" "wordpressdb_sng" {
  name       = "wordpressdb-sn-group"
  subnet_ids = [aws_subnet.simple_webserver_private-db-az1.id, aws_subnet.simple_webserver_private-db-az2.id]
  tags       = var.tags
}
