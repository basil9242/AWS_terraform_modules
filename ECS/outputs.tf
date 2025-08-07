# Cluster Outputs
output "cluster_id" {
  description = "ID of the ECS cluster"
  value       = aws_ecs_cluster.ecs_cluster.id
}

output "cluster_arn" {
  description = "ARN of the ECS cluster"
  value       = aws_ecs_cluster.ecs_cluster.arn
}

output "cluster_name" {
  description = "Name of the ECS cluster"
  value       = aws_ecs_cluster.ecs_cluster.name
}

# Service Outputs
output "service_id" {
  description = "ID of the ECS service"
  value       = var.create_service ? aws_ecs_service.ecs_service[0].id : null
}

output "service_arn" {
  description = "ARN of the ECS service"
  value       = var.create_service ? aws_ecs_service.ecs_service[0].id : null
}

output "service_name" {
  description = "Name of the ECS service"
  value       = var.create_service ? aws_ecs_service.ecs_service[0].name : null
}

# Task Definition Outputs
output "task_definition_arn" {
  description = "ARN of the task definition"
  value       = var.create_service ? aws_ecs_task_definition.ecs_task_definition[0].arn : null
}

output "task_definition_family" {
  description = "Family of the task definition"
  value       = var.create_service ? aws_ecs_task_definition.ecs_task_definition[0].family : null
}

output "task_definition_revision" {
  description = "Revision of the task definition"
  value       = var.create_service ? aws_ecs_task_definition.ecs_task_definition[0].revision : null
}

# IAM Role Outputs
output "execution_role_arn" {
  description = "ARN of the ECS execution role"
  value       = var.create_service ? aws_iam_role.ecs_execution_role[0].arn : null
}

output "task_role_arn" {
  description = "ARN of the ECS task role"
  value       = var.create_task_role ? aws_iam_role.ecs_task_role[0].arn : null
}

output "autoscaling_role_arn" {
  description = "ARN of the ECS autoscaling role"
  value       = var.enable_autoscaling ? aws_iam_role.ecs_autoscaling_role[0].arn : null
}

# Security Group Outputs
output "security_group_id" {
  description = "ID of the ECS service security group"
  value       = var.create_service && var.create_security_group ? aws_security_group.ecs_service_sg[0].id : null
}

output "security_group_arn" {
  description = "ARN of the ECS service security group"
  value       = var.create_service && var.create_security_group ? aws_security_group.ecs_service_sg[0].arn : null
}

# CloudWatch Outputs
output "log_group_name" {
  description = "Name of the CloudWatch log group"
  value       = var.create_service ? aws_cloudwatch_log_group.ecs_logs[0].name : null
}

output "log_group_arn" {
  description = "ARN of the CloudWatch log group"
  value       = var.create_service ? aws_cloudwatch_log_group.ecs_logs[0].arn : null
}

output "exec_log_group_name" {
  description = "Name of the ECS Exec CloudWatch log group"
  value       = var.enable_execute_command ? aws_cloudwatch_log_group.ecs_exec_logs[0].name : null
}

# Auto Scaling Outputs
output "autoscaling_target_resource_id" {
  description = "Resource ID of the autoscaling target"
  value       = var.enable_autoscaling ? aws_appautoscaling_target.ecs_target[0].resource_id : null
}

output "cpu_scaling_policy_arn" {
  description = "ARN of the CPU scaling policy"
  value       = var.enable_autoscaling && var.enable_cpu_scaling ? aws_appautoscaling_policy.ecs_scale_up_cpu[0].arn : null
}

output "memory_scaling_policy_arn" {
  description = "ARN of the memory scaling policy"
  value       = var.enable_autoscaling && var.enable_memory_scaling ? aws_appautoscaling_policy.ecs_scale_up_memory[0].arn : null
}

output "request_scaling_policy_arn" {
  description = "ARN of the request count scaling policy"
  value       = var.enable_autoscaling && var.enable_request_scaling && var.enable_load_balancer ? aws_appautoscaling_policy.ecs_scale_up_requests[0].arn : null
}

# Service Discovery Outputs
output "service_discovery_namespace_id" {
  description = "ID of the service discovery namespace"
  value       = var.enable_service_discovery && var.create_service_discovery_namespace ? aws_service_discovery_private_dns_namespace.ecs_namespace[0].id : null
}

output "service_discovery_namespace_arn" {
  description = "ARN of the service discovery namespace"
  value       = var.enable_service_discovery && var.create_service_discovery_namespace ? aws_service_discovery_private_dns_namespace.ecs_namespace[0].arn : null
}

output "service_discovery_service_id" {
  description = "ID of the service discovery service"
  value       = var.enable_service_discovery ? aws_service_discovery_service.ecs_service_discovery[0].id : null
}

output "service_discovery_service_arn" {
  description = "ARN of the service discovery service"
  value       = var.enable_service_discovery ? aws_service_discovery_service.ecs_service_discovery[0].arn : null
}

# KMS Outputs
output "kms_key_id" {
  description = "ID of the KMS key"
  value       = var.create_service || var.enable_execute_command ? aws_kms_key.ecs_kms_key[0].id : null
}

output "kms_key_arn" {
  description = "ARN of the KMS key"
  value       = var.create_service || var.enable_execute_command ? aws_kms_key.ecs_kms_key[0].arn : null
}

output "kms_alias_name" {
  description = "Name of the KMS key alias"
  value       = var.create_service || var.enable_execute_command ? aws_kms_alias.ecs_kms_alias[0].name : null
}

# CloudWatch Alarms Outputs
output "cpu_alarm_arn" {
  description = "ARN of the CPU utilization alarm"
  value       = var.create_service && var.enable_cloudwatch_alarms ? aws_cloudwatch_metric_alarm.ecs_cpu_high[0].arn : null
}

output "memory_alarm_arn" {
  description = "ARN of the memory utilization alarm"
  value       = var.create_service && var.enable_cloudwatch_alarms ? aws_cloudwatch_metric_alarm.ecs_memory_high[0].arn : null
}

# Capacity Provider Outputs
output "capacity_providers" {
  description = "List of capacity providers associated with the cluster"
  value       = var.enable_capacity_providers ? aws_ecs_cluster_capacity_providers.ecs_cluster_capacity_providers[0].capacity_providers : null
}