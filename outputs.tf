#Output artifactory
output "VPC-ID" {
  description = "The VPC id"
  value       = aws_vpc.wordpress-vpc.id
}
output "bastion-ip" {
  description = "Bastion host IP"
  value       = aws_instance.bastion.public_ip
}
output "wp-master-ip" {
  description = "WordPress Master server IP"
  value       = aws_instance.wordpress_master.public_ip
}
output "RDS-db-url" {
  description = "RDS instance URL"
  value       = aws_db_instance.wordpressdb.address
}
output "RDS-db-username" {
  description = "RDS db username"
  value       = var.dbuser
}
output "RDS-db-pass" {
  description = "RDS db password"
  value       = random_password.dbpass.result
}
output "WP-Admin-username" {
  description = "WordPress Admin username"
  value       = var.wp_admin_name
}
output "WP-Admin-pass" {
  description = "WordPress Admin password"
  value       = random_password.wp_admin_pass.result
}
output "efs_dns" {
  description = "The EFS file system DNS details"
  value       = aws_efs_file_system.wp-filestore.dns_name
}
output "efs-id" {
  description = "EFS files system id"
  value       = aws_efs_file_system.wp-filestore.id
}
output "alb-dns" {
  description = "ALB DNS name"
  value       = aws_lb.wp_alb.dns_name
}
