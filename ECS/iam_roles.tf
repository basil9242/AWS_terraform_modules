# Data sources
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

# ECS Execution Role
resource "aws_iam_role" "ecs_execution_role" {
  count = var.create_service ? 1 : 0
  name  = "${var.cluster_name}-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })

  tags = merge(var.tags, {
    Name        = "${var.cluster_name}-execution-role"
    Environment = var.environment
  })
}

# ECS Execution Role Policy Attachment
resource "aws_iam_role_policy_attachment" "ecs_execution_role_policy" {
  count      = var.create_service ? 1 : 0
  role       = aws_iam_role.ecs_execution_role[0].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Custom Execution Role Policy for ECR and Secrets Manager
resource "aws_iam_role_policy" "ecs_execution_custom_policy" {
  count = var.create_service ? 1 : 0
  name  = "${var.cluster_name}-execution-custom-policy"
  role  = aws_iam_role.ecs_execution_role[0].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = concat([
      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "${aws_cloudwatch_log_group.ecs_logs[0].arn}:*"
      },
      {
        Effect = "Allow"
        Action = [
          "kms:Decrypt"
        ]
        Resource = aws_kms_key.ecs_kms_key[0].arn
      }
    ],
    length(var.secrets_manager_arns) > 0 ? [{
      Effect = "Allow"
      Action = [
        "secretsmanager:GetSecretValue"
      ]
      Resource = var.secrets_manager_arns
    }] : [],
    length(var.ssm_parameter_arns) > 0 ? [{
      Effect = "Allow"
      Action = [
        "ssm:GetParameters",
        "ssm:GetParameter"
      ]
      Resource = var.ssm_parameter_arns
    }] : [])
  })
}

# ECS Task Role (optional)
resource "aws_iam_role" "ecs_task_role" {
  count = var.create_task_role ? 1 : 0
  name  = "${var.cluster_name}-task-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })

  tags = merge(var.tags, {
    Name        = "${var.cluster_name}-task-role"
    Environment = var.environment
  })
}

# Custom Task Role Policy
resource "aws_iam_role_policy" "ecs_task_custom_policy" {
  count = var.create_task_role && var.task_role_policy_json != null ? 1 : 0
  name  = "${var.cluster_name}-task-custom-policy"
  role  = aws_iam_role.ecs_task_role[0].id
  policy = var.task_role_policy_json
}

# Task Role Policy Attachments
resource "aws_iam_role_policy_attachment" "ecs_task_role_policies" {
  count      = var.create_task_role ? length(var.task_role_policy_arns) : 0
  role       = aws_iam_role.ecs_task_role[0].name
  policy_arn = var.task_role_policy_arns[count.index]
}

# Auto Scaling Role (for ECS Service Auto Scaling)
resource "aws_iam_role" "ecs_autoscaling_role" {
  count = var.enable_autoscaling ? 1 : 0
  name  = "${var.cluster_name}-autoscaling-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "application-autoscaling.amazonaws.com"
        }
      }
    ]
  })

  tags = merge(var.tags, {
    Name        = "${var.cluster_name}-autoscaling-role"
    Environment = var.environment
  })
}

# Auto Scaling Role Policy Attachment
resource "aws_iam_role_policy_attachment" "ecs_autoscaling_role_policy" {
  count      = var.enable_autoscaling ? 1 : 0
  role       = aws_iam_role.ecs_autoscaling_role[0].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSServiceRolePolicy"
}