# aws_codepipeline.pipeline:
resource "aws_codepipeline" "pipeline" {
  count    = length(var.service_name)
  name     = aws_codedeploy_app.service_name[count.index].name
  role_arn = ""
  tags = {
    env = "${terraform.workspace}"
    layer = "application"
    app = "${var.service_name[count.index]}"
  }
  tags_all = {}

  artifact_store {
    location = ""
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      category = "Source"
      configuration = {
        "BranchName"           = "QA"
        "ConnectionArn"        = ""
        "DetectChanges"        = "true"
        "FullRepositoryId"     = "${var.service_name[count.index]}"
        "OutputArtifactFormat" = "CODE_ZIP"
      }
      input_artifacts = []
      name            = "Source"
      namespace       = "SourceVariables"
      output_artifacts = [
        "SourceArtifact",
      ]
      owner     = "AWS"
      provider  = "CodeStarSourceConnection"
      region    = var.region
      run_order = 1
      version   = "1"
    }
  }

  stage {
    name = "Build"

    action {
      category = "Build"
      configuration = {
        "PrimarySource" = "SourceArtifact"
        "ProjectName"   = aws_codedeploy_app.service_name[count.index].name
      }
      input_artifacts = [
        "SourceArtifact",
      ]
      name      = aws_codedeploy_app.service_name[count.index].name
      namespace = "BuildVariables"
      output_artifacts = [
        "BuildArtifact",
      ]
      owner     = "AWS"
      provider  = "CodeBuild"
      region    = var.region
      run_order = 1
      version   = "1"
    }
  }

  stage {
    name = "Deploy"

    action {
      category = "Deploy"
      configuration = {
        "AppSpecTemplateArtifact"        = "BuildArtifact"
        "AppSpecTemplatePath"            = "appspec${terraform.workspace == "homologacao" ? "-hom" : ""}.yaml"
        "ApplicationName"                = aws_codedeploy_app.service_name[count.index].name
        "DeploymentGroupName"            = aws_codedeploy_deployment_group.service_name[count.index].app_name
        "Image1ArtifactName"             = "BuildArtifact"
        "Image1ContainerName"            = "IMAGE1_NAME"
        "TaskDefinitionTemplateArtifact" = "BuildArtifact"
        "TaskDefinitionTemplatePath"     = "taskdef${terraform.workspace == "homologacao" ? "-hom" : ""}.json"
      }
      input_artifacts = [
        "BuildArtifact",
      ]
      name             = aws_codedeploy_app.service_name[count.index].name
      namespace        = "DeployVariables"
      output_artifacts = []
      owner            = "AWS"
      provider         = "CodeDeployToECS"
      region           = var.region
      run_order        = 1
      version          = "1"
    }


    # lifecycle {
    #   ignore_changes = all
    # }
  }
}