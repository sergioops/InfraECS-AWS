resource "aws_ecs_service" "ecs_service" {
  count   = length(var.service_name)
  name    = var.service_name[count.index]
  cluster = aws_ecs_cluster.ecs-cluster.name
  load_balancer {
    target_group_arn = aws_lb_target_group.target_group_blue[count.index].arn
    container_name   = var.service_name[count.index]
    container_port   = aws_lb_target_group.target_group_blue[count.index].port
  }
  service_registries {
    registry_arn = aws_service_discovery_service.service_discovery[count.index].arn
  }
  desired_count          = 1
  launch_type            = "FARGATE"
  platform_version       = "1.4.0"
  task_definition        = aws_ecs_task_definition.ecs_task_definition[count.index].arn
  enable_execute_command = true
  propagate_tags         = "TASK_DEFINITION"
  network_configuration {
    assign_public_ip = false
    security_groups = [
      aws_security_group.rede-interna.id
    ]
    subnets = aws_subnet.private[*].id
  }
  health_check_grace_period_seconds = 0
  scheduling_strategy               = "REPLICA"
  deployment_controller {
    type = "CODE_DEPLOY"
  }
  tags = {
    env = "${terraform.workspace}"
    layer = "application"
    app = "${var.service_name[count.index]}"
  }
  lifecycle {
    ignore_changes = all
    create_before_destroy = true
  }
}

resource "aws_service_discovery_service" "service_discovery" {
  count       = length(var.service_name)
  name        = var.service_name[count.index]
  description = "Discovery Service Container"
  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.namespace.id
    dns_records {
      ttl  = 60
      type = "A"
    }

    routing_policy = "MULTIVALUE"
  }
  health_check_custom_config {
    failure_threshold = 1
  }
  tags = {
    env = "${terraform.workspace}"
    layer = "application"
    app = "${var.service_name[count.index]}"
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_appautoscaling_target" "autoscaling_target" {
  count              = length(var.service_name)
  max_capacity       = 10
  min_capacity       = 1
  resource_id        = "service/${aws_ecs_cluster.ecs-cluster.name}/${aws_ecs_service.ecs_service[count.index].name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
  role_arn           = "arn:aws:iam::${var.account_id[terraform.workspace]}:role/aws-service-role/ecs.application-autoscaling.amazonaws.com/AWSServiceRoleForApplicationAutoScaling_ECSService"
  lifecycle {
    ignore_changes = all
    create_before_destroy = true
  }
}

resource "aws_appautoscaling_policy" "autoscaling_policy_cpu" {
  count              = length(var.service_name)
  name               = "AverageCPU"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.autoscaling_target[count.index].resource_id
  scalable_dimension = aws_appautoscaling_target.autoscaling_target[count.index].scalable_dimension
  service_namespace  = aws_appautoscaling_target.autoscaling_target[count.index].service_namespace

  target_tracking_scaling_policy_configuration {
    disable_scale_in   = false
    scale_in_cooldown  = 60
    scale_out_cooldown = 60
    target_value       = 60

    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
  }
  lifecycle {
    ignore_changes = all
    create_before_destroy = true
  }
}