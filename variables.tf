variable "tags" {
  description = "Tags used for the AWS resources created by this template"
  type        = map(string)
}
variable "aws_profile_name" {
  description = "AWS profile to be used for deploying resources"
}
variable "aws_region" {
  description = "AWS region to which resources are to be deployed"
}
variable "domain_name" {
  description = "The FQDN of domain where visitors access the site contents"
}
variable "vpc_cidr_block" {
  description = "CIDR block to be used in VPC"
  default     = "10.0.0.0/8"
}
variable "public-sn-az1" {
  description = "First subnet"
  default     = "10.0.1.0/25"
}
variable "public-sn-az2" {
  description = "First subnet"
  default     = "10.0.1.128/25"
}
variable "private-sn-app-az1" {
  description = "First subnet"
  default     = "10.0.2.0/25"
}
variable "private-sn-app-az2" {
  description = "First subnet"
  default     = "10.0.2.128/25"
}
variable "private-sn-db-az1" {
  description = "First subnet"
  default     = "10.0.3.0/25"
}
variable "private-sn-db-az2" {
  description = "First subnet"
  default     = "10.0.3.128/25"
}
variable "bastion_ami" {
  description = "Bastion host AMI, preferably RHEL"
  type        = map(string)
}
variable "bastion_instance_type" {
  description = "Bastion host type"
  default     = "micro"
}
variable "keyPath" {
  description = "Key file to be used for ssh"
}
variable "keyName" {
  description = "The name of SSH key stored in AWS account"
}
variable "asg_tags" {
  description = "Tags for ASG instances"
  type        = list
}
variable "allowed_ip_list" {
  description = "IP addresses allowed to access resources in VPC"
  type        = list
}
variable "server_instance_type" {
  description = "EC2 instance type needed to be used for creating servers"
}
variable "ami_ids" {
  description = "Server AMI, preferably RHEL"
  type        = map(string)
}
variable dbname {
  description = "Database name to store WordPress data"
}
variable "dbuser" {
  description = "User to access the WordPress database"
}
variable "dbpass" {
  description = "Password for user to authenticate into db"
}
variable "dbhost" {
  description = "Placeholder till DB cluster is setup"
}
variable "wp_admin_name" {
  description = "WordPress site admin user name"
}
variable "wp_admin_pass" {
  description = "WordPress admin login password"
}
variable "wp_admin_email" {
  description = "Email to access password reset for Wordpress Admin"
}
