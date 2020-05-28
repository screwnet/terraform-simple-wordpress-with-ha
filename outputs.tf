output "ns_details" {
  description = "The NS records for domain zone to be added to registrar panel"
  value       = aws_route53_zone.screwnet.name_servers
}
output "efs_details" {
  description = "The EFS file system mount details"
  value       = aws_efs_file_system.wp-filestore.dns_name
}
output "rds_db" {
  description = "RDS instance details for database"
  value       = aws_db_instance.wordpressdb.address
}
output "webserver_master" {
  description = "IP address of webserver master instance"
  value       = aws_instance.wordpress-master.public_ip
}
output "bastion_ip" {
  description = "IP address of bastion host instance"
  value       = aws_instance.bastion.public_ip
}
