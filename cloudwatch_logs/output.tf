output "cloudwatch_logs_arn" {
    description = "cloudwatch log group arn"
    value = aws_cloudwatch_log_group.cloudwatch_logs_group.arn  
}