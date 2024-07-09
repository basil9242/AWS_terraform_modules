data "aws_caller_identity" "current" {}

resource "aws_kms_key" "vpc_kms_key" {
  description             = "symmetric encryption KMS key"
  enable_key_rotation     = true
  deletion_window_in_days = 20
  tags = {
    Name = "VPC_KMS_KEY"
  }
}

resource "aws_kms_key_policy" "vpc_kms_key_ploicy" {
  key_id = aws_kms_key.vpc_kms_key.id
  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "key-default-1"
    Statement = [
      {
        Sid    = "Enable IAM User Permissions"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        Action   = "kms:*"
        Resource = "*"
      }
    ]
  })
}