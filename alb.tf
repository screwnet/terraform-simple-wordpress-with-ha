resource "aws_lb" "wp_alb" {
  name                       = "wordpress-alb"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.bastion_sg.id]
  subnets                    = [aws_subnet.bastion_subnet1.id, aws_subnet.bastion_subnet2.id]
  enable_deletion_protection = false
  access_logs {
    bucket  = aws_s3_bucket.logging_bucket.id
    prefix  = var.lb_log_prefix
    enabled = true
  }
  tags = var.tags
}

resource "aws_lb_listener" "alb_listener_http" {
  load_balancer_arn = aws_lb.wp_alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.wp_tg.arn
  }
}

resource "aws_alb_listener_rule" "wp_http" {
  listener_arn = aws_lb_listener.alb_listener_http.arn
  priority     = 12
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.wp_tg.arn
  }
  condition {
    host_header {
      values = ["nikhil.ninja"]
    }
  }
}

resource "aws_lb_target_group" "wp_tg" {
  name                 = "wordpress-tg"
  port                 = 80
  protocol             = "HTTP"
  target_type          = "instance"
  vpc_id               = aws_vpc.wordpress-vpc.id
  deregistration_delay = 500
  tags                 = var.tags
  health_check {
    enabled  = true
    interval = 10
    path     = "/health.html"
    port     = 80
    timeout  = 8
    matcher  = "200-299"
  }
}

/*resource "aws_alb_target_group_attachment" "tga1_http" {
  target_group_arn = aws_lb_target_group.tg1.arn
  target_id        = aws_instance.ALB_webserver1.id
  port             = 80
}

resource "aws_alb_target_group_attachment" "tga2_http" {
  target_group_arn = aws_lb_target_group.tg2.arn
  target_id        = aws_instance.ALB_webserver2.id
  port             = 80
}
*/
