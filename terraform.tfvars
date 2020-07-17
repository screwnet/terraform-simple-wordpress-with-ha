#Terraform variable value associations
#Currently us-east-1 region needs to be used due to some constraints in the future resource properties
aws_region            = "us-east-1"
aws_profile_name      = "dsdmlab"
vpc_cidr_block        = "10.0.0.0/16"
bastion_sn_az1        = "10.0.1.0/25"
bastion_sn_az2        = "10.0.1.128/25"
allowed_ip_list       = ["157.46.0.0/16"]
keyName               = "ds-dm_nikhil.vinoy_20200424_hvdsdmlab-nv"
DDKey                 = "2698a1fd9fa32b9013bccbd197d5692d"
bastion_instance_type = "t2.micro"
server_instance_type  = "t2.micro"
domain_name           = "nikhil.ninja"
dbname                = "wordpress"
dbuser                = "wordpress"
wp_admin_name         = "wordpressadmin"
wp_admin_email        = "contact@nikhil.ninja"
lb_log_prefix         = "logs"
tags = {
  Name           = "wordpress_webserver"
  Owner          = "nikhil.vinoy"
  Environment    = "Testing"
  Project        = "mgslearning"
  Automated      = "True"
  Framework      = "Terraform"
  Version        = "v0.12.24"
  Delete         = "no_confirm_not-before_2020-07-30"
  ExpirationDate = "2020-07-30"
  Schedule       = "IST"
}
bastion_tags = {
  Name = "bastion_host"
}
bastion_ami = {
  us-east-1 = "ami-098f16afa9edf40be"
  us-west-2 = "ami-02f147dfb8be58a10"
}
ami_ids = {
  us-east-1 = "ami-098f16afa9edf40be"
  us-west-2 = "ami-02f147dfb8be58a10"
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
    value               = "no_confirm_not-before_2020-07-30"
    propagate_at_launch = true
  },
  {
    key                 = "ExpirationDate"
    value               = "2020-07-30"
    propagate_at_launch = true
  },
  {
    key                 = "Schedule"
    value               = "IST"
    propagate_at_launch = true
  }
]
