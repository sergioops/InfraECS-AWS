resource "aws_iam_role" "CodeBuildServiceRole" {
    assume_role_policy    = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
        "Effect": "Allow",
        "Principal": {
            "Service": "codebuild.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
        }
    ]
    }
    )
    description           = "Allows Codebuild to call AWS services on your behalf."
    force_detach_policies = false
    max_session_duration  = 3600
    name                  = "CodeBuildServiceRole"
    name_prefix           = null
    path                  = "/"
    permissions_boundary  = null
    tags = {
        env = "${terraform.workspace}"
        layer = "iam"
    }
    tags_all              = {}
    inline_policy {
        name   = null
        policy = null
    }
}

resource "aws_iam_role" "ecsTaskExecutionRole" {
    assume_role_policy    = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
        "Effect": "Allow",
        "Principal": {
            "Service": "ecs-tasks.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
        }
    ]
    }
    )
    description           = "Allows ECS to call AWS services on your behalf."
    force_detach_policies = false
    max_session_duration  = 3600
    name                  = "ecsTaskExecutionRole"
    name_prefix           = null
    path                  = "/"
    permissions_boundary  = null
    tags = {
        env = "${terraform.workspace}"
        layer = "iam"
    }
    tags_all              = {}
    inline_policy {
        name   = null
        policy = null
    }
}

resource "aws_iam_role" "ecsTaskRole" {
    assume_role_policy    = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
        "Effect": "Allow",
        "Principal": {
            "Service": "ecs-tasks.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
        }
    ]
    }
    )
    description           = "Allows ECS to call AWS services on your behalf."
    force_detach_policies = false
    max_session_duration  = 3600
    name                  = "ecsTaskRole"
    name_prefix           = null
    path                  = "/"
    permissions_boundary  = null
    tags = {
        env = "${terraform.workspace}"
        layer = "iam"
    }
    tags_all              = {}
    inline_policy {
        name   = null
        policy = null
    }
}

resource "aws_iam_role" "AWSCodeDeployRoleForECS" {
    assume_role_policy    = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Principal": {
                "Service": [
                    "codedeploy.amazonaws.com"
                ]
            },
            "Action": "sts:AssumeRole"
        }
    ]
    }
    )
    description           = "Allows CodeDeploy to call AWS services on your behalf."
    force_detach_policies = false
    max_session_duration  = 3600
    name                  = "AWSCodeDeployRoleForECS"
    name_prefix           = null
    path                  = "/"
    permissions_boundary  = null
    tags = {
        env = "${terraform.workspace}"
        layer = "iam"
    }
    tags_all              = {}
    inline_policy {
        name   = null
        policy = null
    }
}

resource "aws_iam_role_policy_attachment" "attach-codebuild" {
  role       = aws_iam_role.CodeBuildServiceRole.name
  policy_arn = "arn:aws:iam::${var.account_id[terraform.workspace]}:policy/${aws_iam_policy.CodeBuildServiceRolePolicy.name}"
}

resource "aws_iam_role_policy_attachment" "attach-taskexec" {
  role       = aws_iam_role.ecsTaskExecutionRole.name
  policy_arn = "arn:aws:iam::${var.account_id[terraform.workspace]}:policy/${aws_iam_policy.AmazonECSTaskExecutionRolePolicy.name}"
}

resource "aws_iam_role_policy_attachment" "attach-task" {
  role       = aws_iam_role.ecsTaskRole.name
  policy_arn = "arn:aws:iam::${var.account_id[terraform.workspace]}:policy/${aws_iam_policy.AmazonECSTaskRolePolicy.name}"
}

resource "aws_iam_role_policy_attachment" "AWSCodeDeployRoleForECS" {
  role       = aws_iam_role.AWSCodeDeployRoleForECS.name
  policy_arn = "arn:aws:iam::${var.account_id[terraform.workspace]}:policy/${aws_iam_policy.AWSCodeDeployRoleForECS.name}"
}

