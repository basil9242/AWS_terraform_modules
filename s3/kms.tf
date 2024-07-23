data "aws_caller_identity" "current" {}

resource "aws_kms_key" "s3_kms" {
  description             = "A symmetric encryption KMS key"
  enable_key_rotation     = true
  deletion_window_in_days = 20
  tags = {
    Name = "s3_kms"
  }
}

resource "aws_kms_key_policy" "s3_poicy" {
  key_id = aws_kms_key.s3_kms.id
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