data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

resource "aws_kms_key" "cloudwatch_kms_key" {
  description             = "KMS key for CloudWatch Logs encryption"
  enable_key_rotation     = var.enable_kms_key_rotation
  deletion_window_in_days = var.kms_key_deletion_window
  tags = merge(var.tags, {
    Name = "cloudwatch-logs-kms-key"
  })
}

resource "aws_kms_key_policy" "cloudwatch_kms_key_policy" {
  key_id = aws_kms_key.cloudwatch_kms_key.id
  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "cloudwatch-logs-key-policy"
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
        Sid    = "Allow CloudWatch Logs Service"
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
            "kms:EncryptionContext:aws:logs:arn" = "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:${var.cloudwatch_log_group_name}"
          }
        }
      }
    ]
  })
}

resource "aws_kms_alias" "alias" {
  name          = "alias/cloudwatch-logs-kms-key"
  target_key_id = aws_kms_key.cloudwatch_kms_key.id
}