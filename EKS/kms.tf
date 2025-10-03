# KMS Key for EKS encryption
resource "aws_kms_key" "eks" {
  count = var.create_kms_key && var.kms_key_arn == "" ? 1 : 0

  description             = "KMS key for EKS cluster ${var.cluster_name} encryption"
  deletion_window_in_days = var.kms_key_deletion_window
  enable_key_rotation     = true

  policy = jsonencode({
    Version = "2012-10-17"
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
        Sid    = "Allow EKS Service"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ]
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
      }
    ]
  })

  tags = merge(var.tags, {
    Name = "${var.cluster_name}-kms-key"
  })
}

# KMS Key Alias
resource "aws_kms_alias" "eks" {
  count = var.create_kms_key && var.kms_key_arn == "" ? 1 : 0

  name          = "alias/${var.cluster_name}-eks-key"
  target_key_id = aws_kms_key.eks[0].key_id
}