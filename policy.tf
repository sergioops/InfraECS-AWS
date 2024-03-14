resource "aws_iam_policy" "CodeBuildServiceRolePolicy" {
    description = null
    name        = "CodeBuildServiceRolePolicy"
    name_prefix = null
    path        = "/"
    policy      = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
        "Sid": "CloudWatchLogsPolicy",
        "Effect": "Allow",
        "Action": [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
        ],
        "Resource": "*"
        },
        {
        "Sid": "CodeCommitPolicy",
        "Effect": "Allow",
        "Action": [
            "codecommit:GitPull"
        ],
        "Resource": "*"
        },
        {
        "Sid": "S3GetObjectPolicy",
        "Effect": "Allow",
        "Action": [
            "s3:GetObject",
            "s3:GetObjectVersion"
        ],
        "Resource": "*"
        },
        {
        "Sid": "S3PutObjectPolicy",
        "Effect": "Allow",
        "Action": [
            "s3:PutObject"
        ],
        "Resource": "*"
        },
        {
        "Sid": "ECRPullPolicy",
        "Effect": "Allow",
        "Action": [
            "ecr:BatchCheckLayerAvailability",
            "ecr:GetDownloadUrlForLayer",
            "ecr:BatchGetImage"
        ],
        "Resource": "*"
        },
        {
        "Sid": "ECRAuthPolicy",
        "Effect": "Allow",
        "Action": [
            "ecr:GetAuthorizationToken"
        ],
        "Resource": "*"
        },
        {
        "Sid": "S3BucketIdentity",
        "Effect": "Allow",
        "Action": [
            "s3:GetBucketAcl",
            "s3:GetBucketLocation"
        ],
        "Resource": "*"
        }
    ]
    }
    )
    tags = {
        env = "${terraform.workspace}"
        layer = "iam"
    }
    tags_all    = {}
}

resource "aws_iam_policy" "AmazonECSTaskRolePolicy" {
    description = null
    name        = "AmazonECSTaskRolePolicy"
    name_prefix = null
    path        = "/"
    policy      = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "*"
        }
    ]
    }
    )
    tags = {
        env = "${terraform.workspace}"
        layer = "iam"
    }
    tags_all    = {}
}

resource "aws_iam_policy" "AmazonECSTaskExecutionRolePolicy" {
    description = null
    name        = "AmazonECSTaskExecutionRolePolicy"
    name_prefix = null
    path        = "/"
    policy      = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ecr:GetAuthorizationToken",
                "ecr:BatchCheckLayerAvailability",
                "ecr:GetDownloadUrlForLayer",
                "ecr:BatchGetImage",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "*"
        }
    ]
    }
    )
    tags = {
        env = "${terraform.workspace}"
        layer = "iam"
    }
    tags_all    = {}
}

resource "aws_iam_policy" "AWSCodeDeployRoleForECS" {
    description = null
    name        = "AWSCodeDeployRoleForECS"
    name_prefix = null
    path        = "/"
    policy      = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
        {
        "Action" : [
            "ecs:DescribeServices",
            "ecs:CreateTaskSet",
            "ecs:UpdateServicePrimaryTaskSet",
            "ecs:DeleteTaskSet",
            "elasticloadbalancing:DescribeTargetGroups",
            "elasticloadbalancing:DescribeListeners",
            "elasticloadbalancing:ModifyListener",
            "elasticloadbalancing:DescribeRules",
            "elasticloadbalancing:ModifyRule",
            "lambda:InvokeFunction",
            "cloudwatch:DescribeAlarms",
            "sns:Publish",
            "s3:GetObject",
            "s3:GetObjectVersion"
        ],
        "Resource" : "*",
        "Effect" : "Allow"
        },
        {
        "Action" : [
            "iam:PassRole"
        ],
        "Effect" : "Allow",
        "Resource" : "*",
        "Condition" : {
            "StringLike" : {
            "iam:PassedToService" : [
                "ecs-tasks.amazonaws.com"
            ]
            }
        }
        }
    ]
    }
    )
    tags = {
        env = "${terraform.workspace}"
        layer = "iam"
    }
    tags_all    = {}
}