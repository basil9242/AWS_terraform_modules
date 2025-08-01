# CloudWatch Metric Filters
resource "aws_cloudwatch_log_metric_filter" "metric_filters" {
  count          = var.create_metric_filters ? length(var.metric_filters) : 0
  name           = var.metric_filters[count.index].name
  pattern        = var.metric_filters[count.index].pattern
  log_group_name = aws_cloudwatch_log_group.cloudwatch_logs_group.name

  metric_transformation {
    name      = var.metric_filters[count.index].metric_name
    namespace = var.metric_filters[count.index].metric_namespace
    value     = var.metric_filters[count.index].metric_value
    default_value = var.metric_filters[count.index].default_value
  }

  depends_on = [aws_cloudwatch_log_group.cloudwatch_logs_group]
}