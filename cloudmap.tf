resource "aws_service_discovery_private_dns_namespace" "namespace" {
  name        = "${var.customer_name}-${terraform.workspace}"
  description = "${var.customer_name}-${terraform.workspace}"
  vpc         = aws_vpc.main.id
  lifecycle {
    create_before_destroy = true
  }
  tags = {
    env = "${terraform.workspace}"
    layer = "application"
  }
}