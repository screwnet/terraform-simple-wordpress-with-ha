# Launch template for ASG
resource "aws_launch_configuration" "simple_webserver-lc" {
  name                        = "webserver-lc"
  image_id                    = aws_ami_from_instance.wordpress-master-ami.id
  instance_type               = var.server_instance_type
  key_name                    = var.keyName
  security_groups             = [aws_security_group.bastion_sg.id]
  associate_public_ip_address = true
  placement_tenancy           = "default"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "simple_webserver-asg" {
  name                      = "wordpress_asg"
  max_size                  = 5
  min_size                  = 1
  default_cooldown          = 60
  health_check_grace_period = 300
  health_check_type         = "EC2"
  desired_capacity          = 2
  launch_configuration      = aws_launch_configuration.simple_webserver-lc.name
  vpc_zone_identifier       = [aws_subnet.bastion_subnet1.id, aws_subnet.bastion_subnet2.id]
  target_group_arns         = [aws_lb_target_group.wp_tg.arn]
  tags                      = var.asg_tags
}
