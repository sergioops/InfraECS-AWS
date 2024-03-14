resource "aws_secretsmanager_secret" "secretmanager" {
  count = length(var.service_name)
  name  = "${terraform.workspace}/${var.service_name[count.index]}"
}