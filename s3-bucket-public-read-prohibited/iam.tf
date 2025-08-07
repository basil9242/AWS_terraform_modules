data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"
    
    principals {
      type        = "Service"
      identifiers = ["config.amazonaws.com"]
    }
    
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "s3_awsconfig_role" {
  name               = "s3-awsconfig-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
  
  tags = var.tags
}

# Enhanced policy for AWS Config
data "aws_iam_policy_document" "s3_awsconfig_policy_document" {
  statement {
    effect = "Allow"
    actions = [
      "config:Put*",
      "config:Get*",
      "config:List*",
      "config:Describe*"
    ]
    resources = ["*"]
  }
  
  statement {
    effect = "Allow"
    actions = [
      "s3:GetBucketAcl",
      "s3:GetBucketPolicy",
      "s3:GetBucketPolicyStatus",
      "s3:GetBucketPublicAccessBlock",
      "s3:GetBucketLocation",
      "s3:ListBucket"
    ]
    resources = ["*"]
  }
  
  dynamic "statement" {
    for_each = var.config_s3_bucket_name != "" ? [1] : []
    content {
      effect = "Allow"
      actions = [
        "s3:PutObject",
        "s3:GetObject",
        "s3:ListBucket"
      ]
      resources = [
        "arn:aws:s3:::${var.config_s3_bucket_name}/*",
        "arn:aws:s3:::${var.config_s3_bucket_name}"
      ]
      
      condition {
        test     = "StringEquals"
        variable = "s3:x-amz-acl"
        values   = ["bucket-owner-full-control"]
      }
    }
  }
  
  # SNS permissions for delivery channel notifications
  dynamic "statement" {
    for_each = (var.create_sns_topic || var.sns_topic_arn != "") ? [1] : []
    content {
      effect = "Allow"
      actions = [
        "sns:Publish"
      ]
      resources = [
        var.create_sns_topic ? "arn:aws:sns:*:*:${var.sns_topic_name}" : var.sns_topic_arn
      ]
    }
  }
}

# Additional IAM role for CloudWatch Events (if notifications are enabled)
resource "aws_iam_role" "cloudwatch_events_role" {
  count = var.enable_compliance_notifications ? 1 : 0
  name  = "s3-config-cloudwatch-events-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "events.amazonaws.com"
        }
      }
    ]
  })

  tags = var.tags
}

# Policy for CloudWatch Events to publish to SNS
resource "aws_iam_role_policy" "cloudwatch_events_sns_policy" {
  count = var.enable_compliance_notifications ? 1 : 0
  name  = "cloudwatch-events-sns-policy"
  role  = aws_iam_role.cloudwatch_events_role[0].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sns:Publish"
        ]
        Resource = var.create_sns_topic ? aws_sns_topic.config_notifications[0].arn : var.sns_topic_arn
      }
    ]
  })
}

resource "aws_iam_role_policy" "s3_awsconfig_policy" {
  name   = "s3-awsconfig-policy"
  role   = aws_iam_role.s3_awsconfig_role.id
  policy = data.aws_iam_policy_document.s3_awsconfig_policy_document.json
}

# Attach AWS managed policy for Config
resource "aws_iam_role_policy_attachment" "config_role_policy" {
  role       = aws_iam_role.s3_awsconfig_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/ConfigRole"
}