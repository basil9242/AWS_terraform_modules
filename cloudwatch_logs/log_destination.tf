# Log Destination for cross-account log sharing
resource "aws_cloudwatch_log_destination" "log_destination" {
  count      = var.create_log_destination ? 1 : 0
  name       = var.log_destination_name
  role_arn   = var.log_destination_role_arn
  target_arn = var.log_destination_target_arn

  tags = merge(var.tags, {
    Name = var.log_destination_name
  })
}

resource "aws_cloudwatch_log_destination_policy" "log_destination_policy" {
  count            = var.create_log_destination ? 1 : 0
  destination_name = aws_cloudwatch_log_destination.log_destination[0].name
  access_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowLogDestinationAccess"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action   = "logs:PutSubscriptionFilter"
        Resource = "arn:aws:logs:*:${data.aws_caller_identity.current.account_id}:destination:${var.log_destination_name}"
      }
    ]
  })
}