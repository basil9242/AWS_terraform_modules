# CloudWatch Log Group for ECS Tasks
resource "aws_cloudwatch_log_group" "ecs_logs" {
  count             = var.create_service ? 1 : 0
  name              = "/ecs/${var.cluster_name}/${var.service_name}"
  retention_in_days = var.log_retention_days
  kms_key_id        = aws_kms_key.ecs_kms_key[0].arn

  tags = merge(var.tags, {
    Name        = "/ecs/${var.cluster_name}/${var.service_name}"
    Environment = var.environment
  })
}

# CloudWatch Log Group for ECS Exec (if enabled)
resource "aws_cloudwatch_log_group" "ecs_exec_logs" {
  count             = var.enable_execute_command ? 1 : 0
  name              = "/ecs/${var.cluster_name}/exec"
  retention_in_days = var.log_retention_days
  kms_key_id        = aws_kms_key.ecs_kms_key[0].arn

  tags = merge(var.tags, {
    Name        = "/ecs/${var.cluster_name}/exec"
    Environment = var.environment
  })
}

# CloudWatch Metric Filters (optional)
resource "aws_cloudwatch_log_metric_filter" "ecs_error_filter" {
  count          = var.create_service && var.enable_error_monitoring ? 1 : 0
  name           = "${var.service_name}-error-filter"
  pattern        = "[timestamp, request_id, level=\"ERROR\", ...]"
  log_group_name = aws_cloudwatch_log_group.ecs_logs[0].name

  metric_transformation {
    name      = "${var.service_name}-errors"
    namespace = "ECS/Application"
    value     = "1"
  }
}

# CloudWatch Alarms
resource "aws_cloudwatch_metric_alarm" "ecs_cpu_high" {
  count               = var.create_service && var.enable_cloudwatch_alarms ? 1 : 0
  alarm_name          = "${var.service_name}-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "300"
  statistic           = "Average"
  threshold           = var.cpu_alarm_threshold
  alarm_description   = "This metric monitors ECS CPU utilization"
  alarm_actions       = var.alarm_actions

  dimensions = {
    ServiceName = aws_ecs_service.ecs_service[0].name
    ClusterName = aws_ecs_cluster.ecs_cluster.name
  }

  tags = merge(var.tags, {
    Name        = "${var.service_name}-cpu-high"
    Environment = var.environment
  })
}

resource "aws_cloudwatch_metric_alarm" "ecs_memory_high" {
  count               = var.create_service && var.enable_cloudwatch_alarms ? 1 : 0
  alarm_name          = "${var.service_name}-memory-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/ECS"
  period              = "300"
  statistic           = "Average"
  threshold           = var.memory_alarm_threshold
  alarm_description   = "This metric monitors ECS memory utilization"
  alarm_actions       = var.alarm_actions

  dimensions = {
    ServiceName = aws_ecs_service.ecs_service[0].name
    ClusterName = aws_ecs_cluster.ecs_cluster.name
  }

  tags = merge(var.tags, {
    Name        = "${var.service_name}-memory-high"
    Environment = var.environment
  })
}