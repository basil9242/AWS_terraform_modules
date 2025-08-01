resource "aws_vpc" "vpc" {
  cidr_block           = var.cidr_block_vpc
  instance_tenancy     = var.vpc_instance_tenancy
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  tags = merge(var.tags, {
    Name        = var.vpc_name
    Environment = var.environment
  })
}

resource "aws_flow_log" "vpc_flow_log" {
  count                = var.enable_flow_logs ? 1 : 0
  iam_role_arn         = aws_iam_role.vpc_logs_role[0].arn
  log_destination      = aws_cloudwatch_log_group.vpc_cloudwatch_logs_group[0].arn
  log_destination_type = "cloud-watch-logs"
  traffic_type         = "ALL"
  vpc_id               = aws_vpc.vpc.id

  tags = merge(var.tags, {
    Name = "${var.vpc_name}-flow-logs"
  })
}

resource "aws_cloudwatch_log_group" "vpc_cloudwatch_logs_group" {
  count             = var.enable_flow_logs ? 1 : 0
  name              = var.vpc_cloudwatch_logs_group_name
  retention_in_days = var.flow_logs_retention_days
  kms_key_id        = aws_kms_key.vpc_kms_key[0].arn

  tags = merge(var.tags, {
    Name = var.vpc_cloudwatch_logs_group_name
  })

  depends_on = [
    aws_kms_key.vpc_kms_key,
    aws_kms_alias.alias
  ]
}

data "aws_iam_policy_document" "vpc_logs_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "vpc_logs_role" {
  count              = var.enable_flow_logs ? 1 : 0
  name               = var.vpc_logs_role_name
  assume_role_policy = data.aws_iam_policy_document.vpc_logs_assume_role.json

  tags = merge(var.tags, {
    Name = var.vpc_logs_role_name
  })
}

data "aws_iam_policy_document" "vpc_logs_assume_policy" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
      "kms:*"
    ]

    resources = [aws_flow_log.vpc_flow_log.arn,aws_cloudwatch_log_group.vpc_cloudwatch_logs_group.arn]
  }
}

resource "aws_iam_role_policy" "vpc_logs_iam_policy" {
  count  = var.enable_flow_logs ? 1 : 0
  name   = "vpc_flow_logs_policy"
  role   = aws_iam_role.vpc_logs_role[0].name
  policy = data.aws_iam_policy_document.vpc_logs_assume_policy.json
}