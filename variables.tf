variable "tags" {
  description = "Default tags to be used across resources"
  type        = map(string)
}
variable "bastion_tags" {
  description = "Tags specific to bastion hosts"
  type        = map(string)
}
variable "aws_profile_name" {
  description = "AWS profile to be used for deploying resources"
}
variable "aws_region" {
  description = "AWS region to which the resources are to be deployed"
  default     = "us-east-1"
}
variable "vpc_cidr_block" {
  description = "CIDR block to be used for resources in the VPC"
  default     = "10.0.0.0/16"
}
variable "bastion_sn_az1" {
  description = "The subnet in public layer where bastion host is residing"
  default     = "10.0.0.0/25"
}
variable "bastion_sn_az2" {
  description = "The subnet in public layer where bastion host is residing"
  default     = "10.0.0.128/25"
}
variable "allowed_ip_list" {
  description = "List of subnets / IP Addresses allowed to access resources in VPC"
  type        = list
}
variable "keyName" {
  description = "SSH key to bind with the instance"
}
variable "bastion_instance_type" {
  description = "The instance class for bastion host"
  default     = "t2.micro"
}
variable "server_instance_type" {
  description = "EC2 instance type needed to be used for creating servers"
}
variable "bastion_ami" {
  description = "List of AMIs to be used for bastion hosts (RHEL)"
  type        = map(string)
}
variable "ami_ids" {
  description = "Server AMI, preferably RHEL"
  type        = map(string)
}
variable "dbname" {
  description = "Database name"
}
variable "dbuser" {
  description = "Database username"
}
variable "domain_name" {
  description = "The FQDN of domain where visitors access the site contents"
}
variable "wp_admin_name" {
  description = "WordPress site admin user name"
}
variable "wp_admin_email" {
  description = "Email to access password reset for Wordpress Admin"
}
variable "asg_tags" {
  description = "Tags for ASG instances"
  type        = list
}
variable "DDKey" {
  description = "Datadog enrollment key"
}
variable "lb_log_prefix" {
  description = "AWS loadbalanacer log prefix for s3"
  default     = "lb_logs"
}
