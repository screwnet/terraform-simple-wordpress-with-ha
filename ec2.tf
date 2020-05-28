# Defines EC2 resources

# Bastion host
resource "aws_instance" "bastion" {
  ami                                  = lookup(var.bastion_ami, var.aws_region)
  instance_type                        = var.bastion_instance_type
  associate_public_ip_address          = true
  subnet_id                            = aws_subnet.simple_webserver_public-az1.id
  vpc_security_group_ids               = [aws_security_group.simple_webserver_web.id]
  tenancy                              = "default"
  disable_api_termination              = "false"
  instance_initiated_shutdown_behavior = "stop"
  monitoring                           = "false"
  source_dest_check                    = "true"
  key_name                             = var.keyName
  tags                                 = var.tags
  volume_tags                          = var.tags
  root_block_device {
    # ebs_block_device { #for attaching a new block device apart from root
    # device_name           = "/dev/xvdb"
    volume_type           = "gp2"
    delete_on_termination = "true"
    volume_size           = 10
    encrypted             = "false"
    #kms_key_id = arn
  }
  credit_specification {
    cpu_credits = "standard"
  }
}

# Wordpress installer. This EC2 instance shall be destroyed after Wordpress is installed on EFS mount
resource "aws_instance" "wordpress-master" {
  ami                                  = lookup(var.ami_ids, var.aws_region)
  instance_type                        = var.server_instance_type
  associate_public_ip_address          = true
  subnet_id                            = aws_subnet.simple_webserver_public-az1.id
  vpc_security_group_ids               = [aws_security_group.simple_webserver_web.id]
  tenancy                              = "default"
  disable_api_termination              = "false"
  instance_initiated_shutdown_behavior = "stop"
  monitoring                           = "false"
  source_dest_check                    = "true"
  key_name                             = var.keyName
  depends_on                           = [aws_internet_gateway.simple_webserver_igw]
  tags                                 = var.tags
  volume_tags                          = var.tags
  root_block_device {
    # ebs_block_device { #for attaching a new block device apart from root
    # device_name           = "/dev/xvdb"
    volume_type           = "gp2"
    delete_on_termination = "true"
    volume_size           = 10
    encrypted             = "false"
    #kms_key_id = arn
  }
  credit_specification {
    cpu_credits = "standard"
  }
  user_data = <<SCRIPT
#!/bin/bash -e

################################################################################
# Bash script to install and setup WordPress in an AMP stack environment
# Supports Linux - RPM based distributions based on RHEL8 and later

#   configure environment
# Configure packages for general OS
dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm -y

# Configure packages for php
dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y
yum install yum-utils -y

# Update existing packages and refresh repo info
yum clean all -y && yum update -y

#   install and configure httpd
yum install -y httpd

#   install and configure php
dnf install php -y
dnf module reset php -y
dnf module enable php:remi-7.4 -y
dnf install php php-cli php-common php-mysql php-opcache php-gd php-curl php-mysqlnd -y

systemctl start httpd

#Mounting EFS
yum install nfs-utils -y

echo "${aws_efs_file_system.wp-filestore.dns_name}:/ /var/www/html nfs defaults,vers=4.1 0 0" >> /etc/fstab
#mount -va

#mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport ${aws_efs_file_system.wp-filestore.dns_name}:/ /var/www/html/

# Waiting for EFS DNS propagation to complete
# sleep 3m

# Setting up environment for WP installation

dbname="${var.dbname}"
dbuser="${var.dbuser}"
dbpass="${var.dbpass}"
dbhost="${aws_db_instance.wordpressdb.address}"
domain="${var.domain_name}"
admin_name="${var.wp_admin_name}"
admin_pass="${var.wp_admin_pass}"
admin_email="${var.wp_admin_email}"
cd /var/www/

# Starting the Wordpress installation process using wp-cli

# MySQL or Mariabd client is required for wp-cli functioning

yum install mariadb -y

curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
cp wp-cli.phar /usr/bin/wp
cd html/
touch favicon.ico
wp core download --allow-root
wp core config --dbhost=$dbhost --dbname=$dbname --dbuser=$dbuser --dbpass=$dbpass --allow-root
chmod 644 wp-config.php
wp core install --url=$domain --title=$domain --admin_name=$admin_name --admin_password=$admin_pass --admin_email=$admin_email --allow-root
touch favicon.jpg
chown -R nobody:nobody .

systemctl restart httpd
systemctl enable httpd
yum update -y

SCRIPT
}

resource "aws_ami_from_instance" "wordpress-master-ami" {
  name               = "wordpress-master-ami"
  source_instance_id = aws_instance.wordpress-master.id
}

/*

resource "aws_ebs_snapshot" "master_wp_ebssnap" {
  volume_id =
}
resource "aws_ami" "master_wp_ami" {
  name                = "master_wp_ami"
  virtualization_type = "hvm"
  root_device_name    = "/dev/xvda"
  ebs_block_device {
    device_name = "/dev/xvda"
    snapshot_id = "snap"
    volume_size = 10
  }
}
*/
