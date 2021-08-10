// task_role
data "aws_iam_policy_document" task_policy {
  statement {
    effect = "Allow"
    actions = [
      "ecs:ListContainerInstances"
    ]
    resources = [aws_ecs_cluster.ecs_cluster.arn]
  }
  statement {
    effect = "Allow"
    actions = [
      "ecs:RunTask"
    ]
    condition {
      test     = "ArnEquals"
      variable = "ecs:cluster"
      values = [
          aws_ecs_cluster.ecs_cluster.arn
      ]
    }
    resources = ["arn:aws:ecs:${var.region}:${var.account_id}:task-definition/*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "ecs:StopTask",
      "ecs:DescribeTasks"
    ]
    condition {
      test     = "ArnEquals"
      variable = "ecs:cluster"
      values = [
          aws_ecs_cluster.ecs_cluster.arn
      ]
    }
    resources = ["arn:aws:ecs:${var.region}:${var.account_id}:task/*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "ssm:PutParameter",
      "ssm:GetParameter",
      "ssm:GetParameters"
    ]
    resources = ["arn:aws:ssm:${var.region}:${var.account_id}:parameter/timeoff*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "kms:Decrypt"
    ]
    resources = ["arn:aws:kms:${var.region}:${var.account_id}:alias/aws/ssm"]
  }
  statement {
    effect = "Allow"
    actions = [
      "iam:PassRole"
    ]
    resources = ["arn:aws:iam::${var.account_id}:role/*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["${aws_cloudwatch_log_group.loggroup.arn}:*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:BatchGetImage",
      "ecr:GetDownloadUrlForLayer",
      "elasticfilesystem:ClientMount",
      "ecr:GetAuthorizationToken",
      "ecs:RegisterTaskDefinition",
      "ecs:ListClusters",
      "ecs:DescribeContainerInstances",
      "ecs:ListTaskDefinitions",
      "ecs:DescribeTaskDefinition",
      "ecs:DeregisterTaskDefinition"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" task_policy {
  name   = "${var.name_prefix}-task-policy"
  policy = data.aws_iam_policy_document.task_policy.json
}

resource "aws_iam_role" task_role {
  name               = "${var.name_prefix}-task-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_assume_policy.json
  tags               = var.tags
}

resource "aws_iam_role_policy_attachment" task {
  role       = aws_iam_role.task_role.name
  policy_arn = aws_iam_policy.task_policy.arn
}


// ecs_execution_role
data "aws_iam_policy_document" ecs_assume_policy {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}
data "aws_iam_policy_document" ecs_execution_policy {
  statement {
    effect = "Allow"
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "logs:CreateLogStream",
      "logs:CreateLogGroup",
      "logs:PutLogEvents"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role" ecs_execution_role {
  name               = "${var.name_prefix}-ecs-execution-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_assume_policy.json
  tags               = var.tags
}

resource "aws_iam_policy" ecs_execution_policy {
  name   = "${var.name_prefix}-ecs-execution-policy"
  policy = data.aws_iam_policy_document.ecs_execution_policy.json
}

resource "aws_iam_role_policy_attachment" ecs_execution {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = aws_iam_policy.ecs_execution_policy.arn
}
