# aws_infra/alb/main.tf

resource "aws_lb" "aws04_alb" {
  name               = "${var.prefix}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [data.aws_security_group.aws04_http_sg.id]
  subnets            = data.aws_subnets.aws04_public_subnets.ids
  tags = {
    Name = "${var.prefix}-alb"
  }
}

# was 대상그룹 생성
resource "aws_lb_target_group" "aws04_alb_was_group" {
  name     = "${var.prefix}-alb-was-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.aws04_vpc.id
  health_check {
    path                = "/"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
    matcher             = "200"
  }
  tags = {
    Name = "${var.prefix}-alb-was-group"
  }
}
# Jankins 대상그룹 생성
resource "aws_lb_target_group" "aws04_alb_jenkins_group" {
  name     = "${var.prefix}-alb-jenkins-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.aws04_vpc.id
  health_check {
    path                = "/login"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
    matcher             = "200"
  }
  tags = {
    Name = "${var.prefix}-alb-jenkins-group"
  }
}

# 리스너 설정
resource "aws_lb_listener" "aws04_alb_listener" {
  load_balancer_arn = aws_lb.aws04_alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = var.certificate_arn
  default_action {
    type             = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "Not Found"
      status_code  = "404"
    }
  }
}

# WAS 리스너 규칙
resource "aws_lb_listener_rule" "aws04_alb_was_rule" {
  listener_arn = aws_lb_listener.aws04_alb_listener.arn
  priority     = 10
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.aws04_alb_was_group.arn
  }
  condition {
    host_header {
      values = ["${var.prefix}-was.busanit.com"]
    }
  }
}

# jenkins 리스너 규칙
resource "aws_lb_listener_rule" "aws04_alb_jenkins_rule" {
  listener_arn = aws_lb_listener.aws04_alb_listener.arn
  priority     = 20
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.aws04_alb_jenkins_group.arn
  }
  condition {
    host_header {
      values = ["${var.prefix}-jenkins.busanit.com"]
    }
  }
}