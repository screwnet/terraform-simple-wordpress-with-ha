aws_region            = "us-east-1"
aws_profile_name      = "dsdmlab"
bastion_instance_type = "t2.micro"
server_instance_type  = "t2.micro"
keyPath               = "../ds-dm_nv.pem"
keyName               = "ds-dm_nikhil.vinoy_20200424_hvdsdmlab-nv"
domain_name           = "screwnet.work"
vpc_cidr_block        = "10.0.0.0/16"
public-sn-az1         = "10.0.1.0/25"
public-sn-az2         = "10.0.1.128/25"
private-sn-app-az1    = "10.0.2.0/25"
private-sn-app-az2    = "10.0.2.128/25"
private-sn-db-az1     = "10.0.3.0/25"
private-sn-db-az2     = "10.0.3.128/25"
allowed_ip_list       = ["117.230.168.238/32"]
dbname                = "wordpress"
dbuser                = "wordpress"
dbpass                = "!-Am_a.J0ck3r.1n_A-HoRs3Sh03"
dbhost                = "localhost"
wp_admin_name         = "wordpressadmin"
wp_admin_pass         = "W0rDPr3$$AdM!n"
wp_admin_email        = "contact@screwnet.work"
bastion_ami = {
  us-east-1 = "ami-098f16afa9edf40be"
  us-west-2 = "ami-02f147dfb8be58a10"
}
ami_ids = {
  us-east-1 = "ami-098f16afa9edf40be"
  us-west-2 = "ami-02f147dfb8be58a10"
}
tags = {
  Name           = "simple_webserver"
  Owner          = "nikhil.vinoy"
  Environment    = "Testing"
  Project        = "mgslearning"
  Automated      = "True"
  Framework      = "Terraform"
  Version        = "v0.12.24"
  Delete         = "no_confirm_not-before_2020-05-30"
  ExpirationDate = "2020-06-05"
  Schedule       = "IST"
}
asg_tags = [
  {
    key                 = "Name"
    value               = "simple_webserver"
    propagate_at_launch = true
  },
  {
    key                 = "Owner"
    value               = "nikhil.vinoy"
    propagate_at_launch = true
  },
  {
    key                 = "Environment"
    value               = "Testing"
    propagate_at_launch = true
  },
  {
    key                 = "Project"
    value               = "mgslearning"
    propagate_at_launch = true
  },

  {
    key                 = "Automated"
    value               = "true"
    propagate_at_launch = true
  },
  {
    key                 = "Framework"
    value               = "Terraform"
    propagate_at_launch = true
  },
  {
    key                 = "Version"
    value               = "v0.12.24"
    propagate_at_launch = true
  },
  {
    key                 = "Delete"
    value               = "no_confirm_not-before_2020-05-30"
    propagate_at_launch = true
  },
  {
    key                 = "ExpirationDate"
    value               = "2020-06-05"
    propagate_at_launch = true
  },
  {
    key                 = "Schedule"
    value               = "IST"
    propagate_at_launch = true
  }
]
