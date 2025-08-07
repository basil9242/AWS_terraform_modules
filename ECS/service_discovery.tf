# Service Discovery Namespace
resource "aws_service_discovery_private_dns_namespace" "ecs_namespace" {
  count       = var.enable_service_discovery && var.create_service_discovery_namespace ? 1 : 0
  name        = var.service_discovery_namespace_name
  description = "Service discovery namespace for ${var.cluster_name}"
  vpc         = var.vpc_id

  tags = merge(var.tags, {
    Name        = var.service_discovery_namespace_name
    Environment = var.environment
  })
}

# Service Discovery Service
resource "aws_service_discovery_service" "ecs_service_discovery" {
  count = var.enable_service_discovery ? 1 : 0
  name  = var.service_discovery_service_name

  dns_config {
    namespace_id = var.create_service_discovery_namespace ? aws_service_discovery_private_dns_namespace.ecs_namespace[0].id : var.service_discovery_namespace_id

    dns_records {
      ttl  = var.service_discovery_dns_ttl
      type = var.service_discovery_dns_type
    }

    routing_policy = var.service_discovery_routing_policy
  }

  dynamic "health_check_custom_config" {
    for_each = var.service_discovery_health_check_grace_period != null ? [1] : []
    content {
      failure_threshold = var.service_discovery_failure_threshold
    }
  }

  tags = merge(var.tags, {
    Name        = var.service_discovery_service_name
    Environment = var.environment
  })
}