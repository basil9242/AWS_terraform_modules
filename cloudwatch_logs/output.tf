output "cloudwatch_logs_arn" {
  description = "CloudWatch log group ARN"
  value       = aws_cloudwatch_log_group.cloudwatch_logs_group.arn
}

output "cloudwatch_logs_name" {
  description = "CloudWatch log group name"
  value       = aws_cloudwatch_log_group.cloudwatch_logs_group.name
}

output "kms_key_id" {
  description = "KMS key ID used for log group encryption"
  value       = aws_kms_key.cloudwatch_kms_key.id
}

output "kms_key_arn" {
  description = "KMS key ARN used for log group encryption"
  value       = aws_kms_key.cloudwatch_kms_key.arn
}

output "kms_alias_name" {
  description = "KMS key alias name"
  value       = aws_kms_alias.alias.name
}

output "log_streams" {
  description = "List of created log streams"
  value       = var.create_log_streams ? aws_cloudwatch_log_stream.log_streams[*].name : []
}

output "metric_filters" {
  description = "List of created metric filters"
  value       = var.create_metric_filters ? aws_cloudwatch_log_metric_filter.metric_filters[*].name : []
}

output "log_destination_arn" {
  description = "ARN of the log destination"
  value       = var.create_log_destination ? aws_cloudwatch_log_destination.log_destination[0].arn : null
}