resource "aws_ecs_task_definition" "ecs_task_definition" {
  count = length(var.service_name)
  container_definitions = jsonencode(
    [
      {
        cpu       = 0
        essential = true
        image     = "public.ecr.aws/h8r5n7n4/nginx:latest"
        logConfiguration = {
          logDriver = "awslogs"
          options = {
            awslogs-group         = "${aws_cloudwatch_log_group.log_groups[count.index].name}"
            awslogs-region        = var.region
            awslogs-stream-prefix = "ecs"
          }
        }
        mountPoints = []
        name        = "${var.service_name[count.index]}"
        portMappings = [
          {
            containerPort = "${aws_lb_target_group.target_group_blue[count.index].port}"
            hostPort      = "${aws_lb_target_group.target_group_blue[count.index].port}"
            protocol      = "tcp"
          },
        ]
        volumesFrom = []
        environment = [
          {
            name  = "NGINX_PORT"
            value = tostring("${aws_lb_target_group.target_group_blue[count.index].port}")
          },
        ]
      },
    ]
  )
  cpu                = "256"
  execution_role_arn = aws_iam_role.ecsTaskExecutionRole.arn
  family             = "${var.service_name[count.index]}-${terraform.workspace}"
  memory             = "512"
  network_mode       = "awsvpc"
  requires_compatibilities = [
    "FARGATE",
  ]
  tags = {
    env = "${terraform.workspace}"
    layer = "application"
    app = "${var.service_name[count.index]}"
  }
  tags_all      = {}
  task_role_arn = aws_iam_role.ecsTaskRole.arn

  runtime_platform {
    operating_system_family = "LINUX"
  }
  #   lifecycle {
  #     ignore_changes = all
  #   }
}