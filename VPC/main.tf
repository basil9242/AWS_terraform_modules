resource "aws_vpc" "vpc" {
    cidr_block = var.cidr_block_vpc
    instance_tenancy = var.vpc_instance_tenancy
    enable_dns_hostnames = var.enable_dns_hostnames
    tags = {
      "Name" = var.vpc_name
    }  
}

resource "aws_subnet" "vpc_subnet" {
    vpc_id = aws_vpc.vpc.id
    
    count = length(var.cidr_block_subnet)
    cidr_block = var.cidr_block_subnet[count.index]
    availability_zone = var.availability_zone[count.index]

    tags = {
        Name = var.subnet_name[count.index]
    }
}

resource "aws_flow_log" "vpc_flow_log" {
    iam_role_arn = aws_iam_role.vpc_logs_role.arn
    log_destination = aws_cloudwatch_log_group.vpc_cloudwatch_logs_group.name
    traffic_type = "ALL"
    vpc_id = aws_vpc.vpc.id  
}

resource "aws_cloudwatch_log_group" "vpc_cloudwatch_logs_group" {
    name = var.vpc_cloudwatch_logs_group_name
    kms_key_id = aws_kms_key.vpc_kms_key.id
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
    name = var.vpc_logs_policy_name
    role = aws_iam_role.vpc_logs_role.arn
    policy = data.aws_iam_policy_document.vpc_logs_assume_policy.json  
}