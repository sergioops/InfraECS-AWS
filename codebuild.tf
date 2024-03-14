# aws_codebuild_project.codebuild:
resource "aws_codebuild_project" "codebuild" {
  count              = length(var.service_name)
  badge_enabled      = false
  build_timeout      = 60
  description        = "${(var.service_name[count.index])}-${terraform.workspace}"
  name               = "${(var.service_name[count.index])}-${terraform.workspace}"
  project_visibility = "PRIVATE"
  queued_timeout     = 480
  service_role       = aws_iam_role.CodeBuildServiceRole.arn
  tags = {
    env = "${terraform.workspace}"
    layer = "application"
    app = "${var.service_name[count.index]}"
  }
  tags_all           = {}

  artifacts {
    encryption_disabled    = false
    name                   = "${(var.service_name[count.index])}-${terraform.workspace}"
    override_artifact_name = false
    packaging              = "NONE"
    type                   = "CODEPIPELINE"
  }


  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:7.0"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true
    type                        = "LINUX_CONTAINER"

    environment_variable {
      name  = "REPONAME"
      value = aws_ecr_repository.ecr_repository[count.index].name
      type  = "PLAINTEXT"
    }
    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      value = var.account_id[terraform.workspace]
      type  = "PLAINTEXT"
    }

  }

  logs_config {
    cloudwatch_logs {
      status = "ENABLED"
    }

    s3_logs {
      encryption_disabled = false
      status              = "DISABLED"
    }
  }

  source {
    buildspec           = "buildspec${terraform.workspace == "homologacao" ? "-hom" : ""}.yml"
    git_clone_depth     = 0
    insecure_ssl        = false
    report_build_status = false
    type                = "CODEPIPELINE"
  }
  vpc_config {
    security_group_ids = [aws_security_group.rede-interna.id]
    subnets            = aws_subnet.private[*].id
    vpc_id             = aws_vpc.main.id
  }
  lifecycle {
    create_before_destroy = true
  }
}