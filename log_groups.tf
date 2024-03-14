resource "aws_cloudwatch_log_group" "log_groups" {
  count             = length(var.service_name)
  name              = "/ecs/${var.service_name[count.index]}-${terraform.workspace}"
  retention_in_days = 7
  tags = {
    env = "${terraform.workspace}"
    layer = "logs"
    app = "${var.service_name[count.index]}"
  }
  tags_all          = {}
}