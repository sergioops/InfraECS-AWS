resource "aws_ecs_cluster" "ecs-cluster" {
  name = terraform.workspace

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
  tags = {
    env = "${terraform.workspace}"
    layer = "application"
  }
}

resource "aws_ecs_cluster_capacity_providers" "fargate_corp" {
  cluster_name = aws_ecs_cluster.ecs-cluster.name

  capacity_providers = ["FARGATE", "FARGATE_SPOT"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 0
    capacity_provider = "FARGATE"
  }

  default_capacity_provider_strategy {
    base              = 0
    weight            = 1
    capacity_provider = "FARGATE_SPOT"
  }
}