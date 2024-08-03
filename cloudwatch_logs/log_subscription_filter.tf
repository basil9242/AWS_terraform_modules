resource "aws_cloudwatch_log_subscription_filter" "cloudwatch_logfilter" {
  count           = var.cloudwatch_log_subscription_filter_requried ? 1 : 0
  name            = "cloudwatch_log_filter"
  role_arn        = aws_iam_role.iam_role_cloudwatch_filter[count.index].arn
  log_group_name  = aws_cloudwatch_log_group.cloudwatch_logs_group.name
  filter_pattern  = var.cloudwatch_log_filter
  destination_arn = var.destination_arn_push_logs
  distribution    = "Random"
}

resource "aws_iam_role_policy" "iam_policy_for_cloudwatch" {
  count = var.cloudwatch_log_subscription_filter_requried ? 1 : 0
  role  = aws_iam_role.iam_role_cloudwatch_filter[count.index].name
  policy = jsonencode({
    Version = "2012-10-17",
    Id      = "cloudwatch_policy",
    Statement = [
      {
        Sid    = "allow logs",
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "arn:aws:logs:*:*:*"
      },
      {
        Sid    = "allow lambda invoke",
        Effect = "Allow",
        Action = [
          "lambda:InvokeFunction"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role" "iam_role_cloudwatch_filter" {
  count = var.cloudwatch_log_subscription_filter_requried ? 1 : 0
  name  = "iam_role_cloudwatch_filter"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "logs.amazonaws.com"
        }
      },
    ]
  })
}