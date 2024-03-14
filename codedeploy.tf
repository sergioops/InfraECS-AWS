resource "aws_codedeploy_deployment_config" "ecs_linear_deployment" {
  deployment_config_name = "CodeDeployCustom.ECSLinear50PercentEvery1Minutes${terraform.workspace}"

  compute_platform = "ECS"

  traffic_routing_config {
    type = "TimeBasedLinear"
    time_based_linear {
      interval   = 1
      percentage = 50
    }
  }
  lifecycle {
    ignore_changes = all
  }
}

# aws_codedeploy_app.service_name:
resource "aws_codedeploy_app" "service_name" {
  count            = length(var.service_name)
  compute_platform = "ECS"
  name             = aws_codebuild_project.codebuild[count.index].name
  tags = {
    env = "${terraform.workspace}"
    layer = "application"
    app = "${var.service_name[count.index]}"
  }
  tags_all         = {}
}

# aws_codedeploy_deployment_group.service_name:
resource "aws_codedeploy_deployment_group" "service_name" {
  count                  = length(var.service_name)
  app_name               = aws_codedeploy_app.service_name[count.index].name
  autoscaling_groups     = []
  deployment_config_name = aws_codedeploy_deployment_config.ecs_linear_deployment.id
  deployment_group_name  = aws_codedeploy_app.service_name[count.index].name
  service_role_arn       = aws_iam_role.AWSCodeDeployRoleForECS.arn
  tags = {
    env = "${terraform.workspace}"
    layer = "application"
  }
  tags_all               = {}

  auto_rollback_configuration {
    enabled = true
    events = [
      "DEPLOYMENT_FAILURE",
    ]
  }

  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout    = "CONTINUE_DEPLOYMENT"
      wait_time_in_minutes = 0
    }

    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = 0
    }
  }

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

  ecs_service {
    cluster_name = aws_ecs_cluster.ecs-cluster.name
    service_name = aws_ecs_service.ecs_service[count.index].name
  }

  load_balancer_info {

    target_group_pair_info {
      prod_traffic_route {
        listener_arns = [
          aws_lb_listener.alb_listener_443.arn,
        ]
      }

      target_group {
        name = aws_lb_target_group.target_group_blue[count.index].name
      }
      target_group {
        name = aws_lb_target_group.target_group_green[count.index].name
      }
    }
  }
  #   lifecycle {
  #     ignore_changes = all
  #   }
}