resource "aws_lb_target_group" "target_group_blue" {
  count = length(var.service_name)
  health_check {
    interval            = 30
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
    healthy_threshold   = 5
    matcher             = "200-399"
  }
  deregistration_delay = 60
  port                 = lookup(var.service_port, var.service_name[count.index])
  protocol             = "HTTP"
  target_type          = "ip"
  vpc_id               = aws_vpc.main.id
  name                 = "${var.service_name[count.index]}-${terraform.workspace == "producao" ? "prd" : terraform.workspace == "homologacao" ? "hml" : ""}-blue"
  # lifecycle {
  #   ignore_changes = all
  # }
  tags = {
    env = "${terraform.workspace}"
    layer = "application"
    app = "${var.service_name[count.index]}"
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_target_group" "target_group_green" {
  count = length(var.service_name)
  health_check {
    interval            = 30
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
    healthy_threshold   = 5
    matcher             = "200-399"
  }
  deregistration_delay = 60
  port                 = lookup(var.service_port, var.service_name[count.index])
  protocol             = "HTTP"
  target_type          = "ip"
  vpc_id               = aws_vpc.main.id
  name                 = "${var.service_name[count.index]}-${terraform.workspace == "producao" ? "prd" : terraform.workspace == "homologacao" ? "hml" : ""}-green"
  # lifecycle {
  #   ignore_changes = all
  # }
  tags = {
    env = "${terraform.workspace}"
    layer = "application"
    app = "${var.service_name[count.index]}"
  }
  lifecycle {
    create_before_destroy = true
  }
}