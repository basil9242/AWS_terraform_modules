output "config_rule_name" {
  description = "Name of the AWS Config rule"
  value       = aws_config_config_rule.prohibhite_s3_bucket_public_access.name
}

output "config_rule_arn" {
  description = "ARN of the AWS Config rule"
  value       = aws_config_config_rule.prohibhite_s3_bucket_public_access.arn
}

output "configuration_recorder_name" {
  description = "Name of the AWS Config configuration recorder"
  value       = aws_config_configuration_recorder.prohibhite_s3_bucket_public_access.name
}

output "delivery_channel_name" {
  description = "Name of the AWS Config delivery channel (if created)"
  value       = var.config_s3_bucket_name != "" ? aws_config_delivery_channel.s3_config_delivery_channel[0].name : null
}

output "delivery_channel_created" {
  description = "Whether a delivery channel was created"
  value       = var.config_s3_bucket_name != ""
}

output "sns_topic_arn" {
  description = "ARN of the SNS topic for Config notifications (if created)"
  value       = var.create_sns_topic ? aws_sns_topic.config_notifications[0].arn : var.sns_topic_arn
}

output "sns_topic_name" {
  description = "Name of the SNS topic for Config notifications (if created)"
  value       = var.create_sns_topic ? aws_sns_topic.config_notifications[0].name : null
}

output "cloudwatch_event_rule_arn" {
  description = "ARN of the CloudWatch Event Rule for compliance notifications (if enabled)"
  value       = var.enable_compliance_notifications ? aws_cloudwatch_event_rule.config_compliance_change[0].arn : null
}

output "iam_role_arn" {
  description = "ARN of the IAM role created for AWS Config"
  value       = aws_iam_role.s3_awsconfig_role.arn
}

output "iam_role_name" {
  description = "Name of the IAM role created for AWS Config"
  value       = aws_iam_role.s3_awsconfig_role.name
}

output "recorder_status" {
  description = "Status of the configuration recorder"
  value       = aws_config_configuration_recorder_status.recorder_status.is_enabled
}