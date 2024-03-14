resource "aws_lb" "loadbalancerv2" {
  name               = "loadbalancer-${terraform.workspace}"
  internal           = false
  load_balancer_type = "application"
  subnets            = aws_subnet.public[*].id
  security_groups = [
    "${aws_security_group.loadbalancer.id}"
  ]
  ip_address_type = "ipv4"
  access_logs {
    enabled = false
    bucket  = ""
    prefix  = ""
  }
  idle_timeout               = "4000"
  enable_deletion_protection = "false"
  enable_http2               = "true"
  tags = {
    env = "${terraform.workspace}"
    layer = "application"
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener" "alb_listener_80" {
  load_balancer_arn = aws_lb.loadbalancerv2.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    redirect {
      host        = "#{host}"
      path        = "/#{path}"
      port        = "443"
      protocol    = "HTTPS"
      query       = "#{query}"
      status_code = "HTTP_301"
    }
    type = "redirect"
  }
  tags = {
    env = "${terraform.workspace}"
    layer = "application"
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener" "alb_listener_443" {
  load_balancer_arn = aws_lb.loadbalancerv2.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.certificate_arn[terraform.workspace]["corp"][0]
  default_action {
    fixed_response {
      content_type = "text/plain"
      status_code  = "503"
    }
    type = "fixed-response"
  }
  tags = {
    env = "${terraform.workspace}"
    layer = "application"
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener_rule" "listener_rule" {
  count        = length(var.service_name)
  listener_arn = aws_lb_listener.alb_listener_443.arn
  action {
    type = "forward"
    forward {
      target_group {
        arn    = aws_lb_target_group.target_group_blue[count.index].arn
        weight = 100
      }
      target_group {
        arn    = aws_lb_target_group.target_group_green[count.index].arn
        weight = 0
      }
    }
  }
  condition {
    host_header {
      values = [
        "${lookup(var.subdomain[terraform.workspace], var.service_name[count.index])}.${var.domain[terraform.workspace]["corp"][0]}"
      ]
    }
  }
  lifecycle {
    ignore_changes = [
      action,
    ]
    create_before_destroy = true
  }
  tags = {
    env = "${terraform.workspace}"
    layer = "application"
    app = "${var.service_name[count.index]}"
  }

}