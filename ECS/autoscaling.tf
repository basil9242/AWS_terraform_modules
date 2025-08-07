# Application Auto Scaling Target
resource "aws_appautoscaling_target" "ecs_target" {
  count              = var.enable_autoscaling ? 1 : 0
  max_capacity       = var.autoscaling_max_capacity
  min_capacity       = var.autoscaling_min_capacity
  resource_id        = "service/${aws_ecs_cluster.ecs_cluster.name}/${aws_ecs_service.ecs_service[0].name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
  role_arn          = aws_iam_role.ecs_autoscaling_role[0].arn

  tags = merge(var.tags, {
    Name        = "${var.service_name}-autoscaling-target"
    Environment = var.environment
  })
}

# Auto Scaling Policy - Scale Up (CPU)
resource "aws_appautoscaling_policy" "ecs_scale_up_cpu" {
  count              = var.enable_autoscaling && var.enable_cpu_scaling ? 1 : 0
  name               = "${var.service_name}-scale-up-cpu"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target[0].resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target[0].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value       = var.cpu_target_value
    scale_in_cooldown  = var.scale_in_cooldown
    scale_out_cooldown = var.scale_out_cooldown
  }
}

# Auto Scaling Policy - Scale Up (Memory)
resource "aws_appautoscaling_policy" "ecs_scale_up_memory" {
  count              = var.enable_autoscaling && var.enable_memory_scaling ? 1 : 0
  name               = "${var.service_name}-scale-up-memory"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target[0].resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target[0].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }
    target_value       = var.memory_target_value
    scale_in_cooldown  = var.scale_in_cooldown
    scale_out_cooldown = var.scale_out_cooldown
  }
}

# Auto Scaling Policy - Custom Metric (ALB Request Count)
resource "aws_appautoscaling_policy" "ecs_scale_up_requests" {
  count              = var.enable_autoscaling && var.enable_request_scaling && var.enable_load_balancer ? 1 : 0
  name               = "${var.service_name}-scale-up-requests"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target[0].resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target[0].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ALBRequestCountPerTarget"
      resource_label        = var.alb_resource_label
    }
    target_value       = var.request_count_target_value
    scale_in_cooldown  = var.scale_in_cooldown
    scale_out_cooldown = var.scale_out_cooldown
  }
}

# Scheduled Scaling (optional)
resource "aws_appautoscaling_scheduled_action" "ecs_scheduled_scaling" {
  count              = var.enable_scheduled_scaling ? length(var.scheduled_scaling_actions) : 0
  name               = var.scheduled_scaling_actions[count.index].name
  service_namespace  = aws_appautoscaling_target.ecs_target[0].service_namespace
  resource_id        = aws_appautoscaling_target.ecs_target[0].resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target[0].scalable_dimension
  schedule           = var.scheduled_scaling_actions[count.index].schedule

  scalable_target_action {
    min_capacity = var.scheduled_scaling_actions[count.index].min_capacity
    max_capacity = var.scheduled_scaling_actions[count.index].max_capacity
  }
}