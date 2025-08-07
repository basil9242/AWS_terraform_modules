resource "aws_config_config_rule" "prohibhite_s3_bucket_public_access" {
  name = var.config_rule_name

  source {
    owner             = "AWS"
    source_identifier = "S3_BUCKET_PUBLIC_READ_PROHIBITED"
  }

  depends_on = [aws_config_configuration_recorder.prohibhite_s3_bucket_public_access]

  tags = var.tags
}

resource "aws_config_configuration_recorder" "prohibhite_s3_bucket_public_access" {
  name     = var.config_rule_recorder_name
  role_arn = aws_iam_role.s3_awsconfig_role.arn

  recording_group {
    all_supported                 = false
    include_global_resource_types = false
    resource_types                = ["AWS::S3::Bucket"]
  }
}

# Add delivery channel only if bucket is specified
resource "aws_config_delivery_channel" "s3_config_delivery_channel" {
  count          = var.config_s3_bucket_name != "" ? 1 : 0
  name           = var.delivery_channel_name
  s3_bucket_name = var.config_s3_bucket_name
  s3_key_prefix  = var.config_s3_key_prefix
  
  dynamic "sns_topic_arn" {
    for_each = var.sns_topic_arn != "" ? [var.sns_topic_arn] : []
    content {
      sns_topic_arn = sns_topic_arn.value
    }
  }

  depends_on = [aws_config_configuration_recorder.prohibhite_s3_bucket_public_access]
}

# SNS Topic for Config notifications (optional)
resource "aws_sns_topic" "config_notifications" {
  count = var.create_sns_topic ? 1 : 0
  name  = var.sns_topic_name
  
  tags = var.tags
}

# SNS Topic Policy to allow Config service to publish
resource "aws_sns_topic_policy" "config_notifications_policy" {
  count = var.create_sns_topic ? 1 : 0
  arn   = aws_sns_topic.config_notifications[0].arn

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowConfigServiceToPublish"
        Effect = "Allow"
        Principal = {
          Service = "config.amazonaws.com"
        }
        Action   = "SNS:Publish"
        Resource = aws_sns_topic.config_notifications[0].arn
        Condition = {
          StringEquals = {
            "AWS:SourceAccount" = data.aws_caller_identity.current.account_id
          }
        }
      }
    ]
  })
}

# CloudWatch Event Rule for Config compliance changes
resource "aws_cloudwatch_event_rule" "config_compliance_change" {
  count       = var.enable_compliance_notifications ? 1 : 0
  name        = "${var.config_rule_name}-compliance-change"
  description = "Capture Config compliance changes for S3 bucket public read rule"

  event_pattern = jsonencode({
    source      = ["aws.config"]
    detail-type = ["Config Rules Compliance Change"]
    detail = {
      configRuleName = [var.config_rule_name]
      newEvaluationResult = {
        complianceType = ["NON_COMPLIANT"]
      }
    }
  })

  tags = var.tags
}

# CloudWatch Event Target to SNS
resource "aws_cloudwatch_event_target" "sns_target" {
  count     = var.enable_compliance_notifications ? 1 : 0
  rule      = aws_cloudwatch_event_rule.config_compliance_change[0].name
  target_id = "SendToSNS"
  arn       = var.create_sns_topic ? aws_sns_topic.config_notifications[0].arn : var.sns_topic_arn

  input_transformer {
    input_paths = {
      rule_name       = "$.detail.configRuleName"
      compliance_type = "$.detail.newEvaluationResult.complianceType"
      resource_type   = "$.detail.resourceType"
      resource_id     = "$.detail.resourceId"
      aws_region      = "$.detail.awsRegion"
      aws_account_id  = "$.detail.awsAccountId"
    }
    input_template = jsonencode({
      "alert_type" = "AWS Config Compliance Alert"
      "rule_name" = "<rule_name>"
      "compliance_status" = "<compliance_type>"
      "resource_type" = "<resource_type>"
      "resource_id" = "<resource_id>"
      "aws_region" = "<aws_region>"
      "aws_account_id" = "<aws_account_id>"
      "message" = "S3 Bucket '<resource_id>' is now <compliance_type> for rule '<rule_name>'"
      "timestamp" = "$${aws.events.event.ingestion-time}"
    })
  }
}

# Data source to get current AWS account ID
data "aws_caller_identity" "current" {}

# Enable configuration recorder
resource "aws_config_configuration_recorder_status" "recorder_status" {
  name       = aws_config_configuration_recorder.prohibhite_s3_bucket_public_access.name
  is_enabled = true
  depends_on = [
    aws_config_configuration_recorder.prohibhite_s3_bucket_public_access,
    aws_config_delivery_channel.s3_config_delivery_channel
  ]
}
