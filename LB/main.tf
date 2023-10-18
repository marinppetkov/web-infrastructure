# create application load balancer
resource "aws_lb" "alb" {
  name               = "web-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.pub-snet-1.id, aws_subnet.pub-snet-2.id]
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
  vpc_id      = aws_vpc.app-vpc.id

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
  target_id        = aws_instance.web-server.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "attachment-tg-web2" {
  target_group_arn = aws_lb_target_group.http-tg.arn
  target_id        = aws_instance.web-server-2.id
  port             = 80
}

