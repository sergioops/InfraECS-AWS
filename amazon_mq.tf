resource "aws_mq_broker" "rabbit" {
  broker_name = "sergiops"

  configuration {
    id       = aws_mq_configuration.config-rabbit.id
    revision = aws_mq_configuration.config-rabbit.latest_revision
  }

  engine_type        = "RabbitMQ"
  engine_version     = "3.11.28"
  host_instance_type = "mq.m5.large"
  security_groups    = [aws_security_group.rede-interna.id]
  deployment_mode = "CLUSTER_MULTI_AZ"
  publicly_accessible = "false"
  subnet_ids = aws_subnet.private[*].id

  user {
    username = var.rabbit_username
    password = jsondecode(data.aws_secretsmanager_secret_version.current.secret_string)["rabbit"]
  }
}

resource "aws_mq_configuration" "config-rabbit" {
  description    = "Rabbit Configuration"
  name           = "sergiops-RabbitConfig"
  engine_type    = "RabbitMQ"
  engine_version = "3.11.28"

  data = <<DATA
# Default RabbitMQ delivery acknowledgement timeout is 30 minutes in milliseconds
consumer_timeout = 1800000
DATA
}