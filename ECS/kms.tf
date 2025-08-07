# KMS Key for ECS encryption
resource "aws_kms_key" "ecs_kms_key" {
  count                   = var.create_service || var.enable_execute_command ? 1 : 0
  description             = "KMS key for ECS cluster ${var.cluster_name}"
  enable_key_rotation     = var.enable_kms_key_rotation
  deletion_window_in_days = var.kms_key_deletion_window

  tags = merge(var.tags, {
    Name        = "${var.cluster_name}-kms-key"
    Environment = var.environment
  })
}

# KMS Key Policy
resource "aws_kms_key_policy" "ecs_kms_key_policy" {
  count  = var.create_service || var.enable_execute_command ? 1 : 0
  key_id = aws_kms_key.ecs_kms_key[0].id
  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "ecs-kms-key-policy"
    Statement = [
      {
        Sid    = "Enable IAM User Permissions"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action   = "kms:*"
        Resource = "*"
      },
      {
        Sid    = "Allow CloudWatch Logs"
        Effect = "Allow"
        Principal = {
          Service = "logs.${data.aws_region.current.name}.amazonaws.com"
        }
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ]
        Resource = "*"
        Condition = {
          ArnEquals = {
            "kms:EncryptionContext:aws:logs:arn" = [
              "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/ecs/${var.cluster_name}/${var.service_name}",
              "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/ecs/${var.cluster_name}/exec"
            ]
          }
        }
      },
      {
        Sid    = "Allow ECS Tasks"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ]
        Resource = "*"
      }
    ]
  })
}

# KMS Alias
resource "aws_kms_alias" "ecs_kms_alias" {
  count         = var.create_service || var.enable_execute_command ? 1 : 0
  name          = "alias/${var.cluster_name}-ecs-key"
  target_key_id = aws_kms_key.ecs_kms_key[0].key_id
}