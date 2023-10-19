# create application load balancer
resource "aws_lb" "alb" {
  name               = "web-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]
  subnets            = [var.pub_snet_1_id, var.pub_snet_2_id]
  enable_deletion_protection = false

  tags   = {
    Name = "http-alb"
  }
}

resource "aws_lb_target_group" "http-tg" {
  name        = "http-tg"
  target_type = "instance"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id

  health_check {
    enabled             = true
    interval            = 300
    path                = "/"
    timeout             = 60
    matcher             = 200
    healthy_threshold   = 2
    unhealthy_threshold = 5
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener" "alb_http_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.http-tg.arn
  }
}

resource "aws_lb_target_group_attachment" "attachment-tg-web1" {
  target_group_arn = aws_lb_target_group.http-tg.arn
  target_id        = var.web_server_1_id
  port             = 80
}

resource "aws_lb_target_group_attachment" "attachment-tg-web2" {
  target_group_arn = aws_lb_target_group.http-tg.arn
  target_id        = var.web_server_2_id
  port             = 80
}

