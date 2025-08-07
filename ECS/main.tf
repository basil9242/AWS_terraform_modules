# ECS Cluster
resource "aws_ecs_cluster" "ecs_cluster" {
  name = var.cluster_name

  dynamic "configuration" {
    for_each = var.enable_execute_command ? [1] : []
    content {
      execute_command_configuration {
        kms_key_id = aws_kms_key.ecs_kms_key[0].arn
        logging    = "OVERRIDE"

        log_configuration {
          cloud_watch_encryption_enabled = true
          cloud_watch_log_group_name     = aws_cloudwatch_log_group.ecs_exec_logs[0].name
        }
      }
    }
  }

  dynamic "setting" {
    for_each = var.enable_container_insights ? [1] : []
    content {
      name  = "containerInsights"
      value = "enabled"
    }
  }

  tags = merge(var.tags, {
    Name        = var.cluster_name
    Environment = var.environment
  })
}

# ECS Cluster Capacity Providers
resource "aws_ecs_cluster_capacity_providers" "ecs_cluster_capacity_providers" {
  count        = var.enable_capacity_providers ? 1 : 0
  cluster_name = aws_ecs_cluster.ecs_cluster.name

  capacity_providers = var.capacity_providers

  dynamic "default_capacity_provider_strategy" {
    for_each = var.default_capacity_provider_strategy
    content {
      capacity_provider = default_capacity_provider_strategy.value.capacity_provider
      weight            = default_capacity_provider_strategy.value.weight
      base              = default_capacity_provider_strategy.value.base
    }
  }
}

# ECS Service
resource "aws_ecs_service" "ecs_service" {
  count           = var.create_service ? 1 : 0
  name            = var.service_name
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.ecs_task_definition[0].arn
  desired_count   = var.desired_count
  launch_type     = var.launch_type

  # Network Configuration
  dynamic "network_configuration" {
    for_each = var.network_mode == "awsvpc" ? [1] : []
    content {
      subnets          = var.subnet_ids
      security_groups  = var.create_security_group && var.create_service ? [aws_security_group.ecs_service_sg[0].id] : var.existing_security_group_ids
      assign_public_ip = var.assign_public_ip
    }
  }

  # Load Balancer Configuration
  dynamic "load_balancer" {
    for_each = var.enable_load_balancer ? [1] : []
    content {
      target_group_arn = var.target_group_arn
      container_name   = var.container_name
      container_port   = var.container_port
    }
  }

  # Service Discovery
  dynamic "service_registries" {
    for_each = var.enable_service_discovery ? [1] : []
    content {
      registry_arn = aws_service_discovery_service.ecs_service_discovery[0].arn
    }
  }

  # Deployment Configuration
  deployment_maximum_percent         = var.deployment_maximum_percent
  deployment_minimum_healthy_percent = var.deployment_minimum_healthy_percent

  dynamic "deployment_circuit_breaker" {
    for_each = var.enable_deployment_circuit_breaker ? [1] : []
    content {
      enable   = true
      rollback = var.enable_deployment_rollback
    }
  }

  dynamic "deployment_controller" {
    for_each = var.deployment_controller_type != null ? [1] : []
    content {
      type = var.deployment_controller_type
    }
  }

  # Auto Scaling
  dynamic "capacity_provider_strategy" {
    for_each = var.enable_capacity_providers && var.launch_type == null ? var.capacity_provider_strategy : []
    content {
      capacity_provider = capacity_provider_strategy.value.capacity_provider
      weight            = capacity_provider_strategy.value.weight
      base              = capacity_provider_strategy.value.base
    }
  }

  # Enable Execute Command (only when required)
  enable_execute_command = var.enable_execute_command ? true : null

  tags = merge(var.tags, {
    Name        = var.service_name
    Environment = var.environment
  })

  depends_on = [
    aws_ecs_task_definition.ecs_task_definition,
    aws_security_group.ecs_service_sg
  ]
}
