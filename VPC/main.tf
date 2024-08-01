resource "aws_vpc" "vpc" {
    cidr_block = var.cidr_block_vpc
    instance_tenancy = var.vpc_instance_tenancy
    enable_dns_hostnames = var.enable_dns_hostnames
    tags = {
      "Name" = var.vpc_name
    }  
}

resource "aws_flow_log" "vpc_flow_log" {
    iam_role_arn = aws_iam_role.vpc_logs_role.arn
    log_destination = aws_cloudwatch_log_group.vpc_cloudwatch_logs_group.arn
    traffic_type = "ALL"
    vpc_id = aws_vpc.vpc.id  
}

resource "aws_cloudwatch_log_group" "vpc_cloudwatch_logs_group" {
    name = var.vpc_cloudwatch_logs_group_name
    retention_in_days = 30
    kms_key_id = aws_kms_key.vpc_kms_key.id
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
  name               = var.vpc_logs_role_name
  assume_role_policy = data.aws_iam_policy_document.vpc_logs_assume_role.json
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
    ]

    resources = [aws_flow_log.vpc_flow_log.arn,aws_cloudwatch_log_group.vpc_cloudwatch_logs_group.arn]
  }
}

resource "aws_iam_role_policy" "vpc_logs_iam_policy" {
    name = "vpc_policy"
    role = aws_iam_role.vpc_logs_role.name
    policy = data.aws_iam_policy_document.vpc_logs_assume_policy.json  
}