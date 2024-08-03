resource "aws_cloudwatch_log_group" "cloudwatch_logs_group" {
  name              = var.cloudwatch_log_group_name
  skip_destroy      = var.log_group_skip_destroy
  log_group_class   = var.log_group_class
  retention_in_days = var.logs_retention_in_days
  kms_key_id        = aws_kms_key.cloudwatch_kms_key.arn
  tags = {
    Name = var.cloudwatch_log_group_name
  }
  depends_on = [
    aws_kms_key.cloudwatch_kms_key,
    aws_kms_alias.alias
  ]
}