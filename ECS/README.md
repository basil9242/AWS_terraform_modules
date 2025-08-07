# AWS ECS Terraform Module

A comprehensive Terraform module for creating and managing AWS Elastic Container Service (ECS) resources with advanced features including auto-scaling, service discovery, load balancer integration, and comprehensive monitoring.

## Features

- ✅ **ECS Clusters** with Container Insights and capacity providers
- ✅ **ECS Services** with Fargate and EC2 launch types
- ✅ **Task Definitions** with advanced container configurations
- ✅ **Auto Scaling** with CPU, memory, and request-based scaling
- ✅ **Service Discovery** with AWS Cloud Map integration
- ✅ **Load Balancer Integration** with ALB/NLB support
- ✅ **Security Groups** with configurable ingress/egress rules
- ✅ **CloudWatch Logging** with KMS encryption
- ✅ **ECS Exec** for debugging and troubleshooting
- ✅ **IAM Roles** with least-privilege policies
- ✅ **KMS Encryption** for logs and ECS Exec
- ✅ **Comprehensive Monitoring** with CloudWatch alarms

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                      ECS Cluster                           │
│  ┌─────────────────────────────────────────────────────┐   │
│  │                ECS Service                          │   │
│  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐ │   │
│  │  │    Task     │  │    Task     │  │    Task     │ │   │
│  │  │ Container(s)│  │ Container(s)│  │ Container(s)│ │   │
│  │  └─────────────┘  └─────────────┘  └─────────────┘ │   │
│  └─────────────────────────────────────────────────────┘   │
│                           │                               │
│  ┌─────────────────────────────────────────────────────┐   │
│  │              Load Balancer                          │   │
│  └─────────────────────────────────────────────────────┘   │
│                           │                               │
│  ┌─────────────────────────────────────────────────────┐   │
│  │            Service Discovery                        │   │
│  └─────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

## Usage

### Basic ECS Service (Fargate)

```hcl
module "ecs_service" {
  source = "git::https://github.com/basil9242/AWS_terraform_modules.git//ECS"
  
  # Cluster Configuration
  cluster_name = "my-app-cluster"
  
  # Service Configuration
  service_name    = "my-web-service"
  desired_count   = 2
  launch_type     = "FARGATE"
  
  # Network Configuration
  vpc_id     = "vpc-12345678"
  subnet_ids = ["subnet-12345678", "subnet-87654321"]
  
  # Task Definition
  task_definition_family = "my-web-app"
  task_cpu              = "512"
  task_memory           = "1024"
  
  # Container Configuration
  container_name  = "web-app"
  container_image = "nginx:latest"
  container_port  = 80
  
  # Security Group
  security_group_ingress_rules = [
    {
      from_port   = 80
      to_port     = 80
      ip_protocol = "tcp"
      cidr_ipv4   = "10.0.0.0/16"
      description = "HTTP traffic from VPC"
    }
  ]
  
  tags = {
    Environment = "production"
    Application = "web-app"
  }
}
```

### Advanced ECS Service with All Features

```hcl
module "ecs_advanced" {
  source = "git::https://github.com/basil9242/AWS_terraform_modules.git//ECS"
  
  # Cluster Configuration
  cluster_name             = "production-cluster"
  enable_container_insights = true
  enable_execute_command   = true
  
  # Capacity Providers
  enable_capacity_providers = true
  capacity_providers       = ["FARGATE", "FARGATE_SPOT"]
  default_capacity_provider_strategy = [
    {
      capacity_provider = "FARGATE"
      weight           = 1
      base             = 1
    },
    {
      capacity_provider = "FARGATE_SPOT"
      weight           = 4
      base             = 0
    }
  ]
  
  # Service Configuration
  service_name  = "advanced-web-service"
  desired_count = 3
  launch_type   = null  # Use capacity providers
  
  # Network Configuration
  vpc_id           = "vpc-12345678"
  subnet_ids       = ["subnet-12345678", "subnet-87654321", "subnet-11111111"]
  assign_public_ip = false
  
  # Task Definition
  task_definition_family   = "advanced-web-app"
  task_cpu                = "1024"
  task_memory             = "2048"
  requires_compatibilities = ["FARGATE"]
  
  # Container Configuration
  container_name   = "web-app"
  container_image  = "my-account.dkr.ecr.us-east-1.amazonaws.com/my-app:latest"
  container_cpu    = 512
  container_memory = 1024
  container_port   = 8080
  
  # Environment Variables and Secrets
  environment_variables = {
    NODE_ENV = "production"
    PORT     = "8080"
  }
  
  secrets = [
    {
      name      = "DATABASE_PASSWORD"
      valueFrom = "arn:aws:secretsmanager:us-east-1:123456789012:secret:db-password-abc123"
    }
  ]
  
  # Health Check
  enable_health_check       = true
  health_check_command      = ["CMD-SHELL", "curl -f http://localhost:8080/health || exit 1"]
  health_check_interval     = 30
  health_check_timeout      = 5
  health_check_retries      = 3
  health_check_start_period = 60
  
  # Load Balancer Integration
  enable_load_balancer = true
  target_group_arn     = "arn:aws:elasticloadbalancing:us-east-1:123456789012:targetgroup/my-targets/1234567890123456"
  
  # Security Group Configuration
  security_group_ingress_rules = [
    {
      from_port   = 8080
      to_port     = 8080
      ip_protocol = "tcp"
      cidr_ipv4   = "10.0.0.0/16"
      description = "Application traffic from VPC"
    }
  ]
  
  # Auto Scaling
  enable_autoscaling      = true
  autoscaling_min_capacity = 2
  autoscaling_max_capacity = 20
  
  enable_cpu_scaling    = true
  enable_memory_scaling = true
  cpu_target_value     = 70
  memory_target_value  = 80
  
  # Service Discovery
  enable_service_discovery           = true
  create_service_discovery_namespace = true
  service_discovery_namespace_name   = "production.local"
  service_discovery_service_name     = "web-app"
  
  # IAM Configuration
  create_task_role = true
  task_role_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
  ]
  
  secrets_manager_arns = [
    "arn:aws:secretsmanager:us-east-1:123456789012:secret:db-password-*"
  ]
  
  # Monitoring
  enable_cloudwatch_alarms = true
  enable_error_monitoring  = true
  cpu_alarm_threshold     = 80
  memory_alarm_threshold  = 85
  alarm_actions          = ["arn:aws:sns:us-east-1:123456789012:alerts"]
  
  # Logging
  log_retention_days = 30
  
  # Deployment Configuration
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 50
  enable_deployment_circuit_breaker  = true
  enable_deployment_rollback         = true
  
  # Volumes (EFS example)
  volumes = [
    {
      name = "efs-storage"
      efs_volume_configuration = {
        file_system_id     = "fs-12345678"
        root_directory     = "/app/data"
        transit_encryption = "ENABLED"
      }
    }
  ]
  
  mount_points = [
    {
      sourceVolume  = "efs-storage"
      containerPath = "/app/data"
      readOnly      = false
    }
  ]
  
  # Tagging
  environment = "production"
  tags = {
    Owner       = "platform-team"
    CostCenter  = "engineering"
    Application = "web-app"
    Tier        = "application"
  }
}
```

### Microservices Setup

```hcl
locals {
  microservices = {
    user-service = {
      image = "my-account.dkr.ecr.us-east-1.amazonaws.com/user-service:latest"
      port  = 8080
      cpu   = 512
      memory = 1024
    }
    order-service = {
      image = "my-account.dkr.ecr.us-east-1.amazonaws.com/order-service:latest"
      port  = 8081
      cpu   = 256
      memory = 512
    }
    payment-service = {
      image = "my-account.dkr.ecr.us-east-1.amazonaws.com/payment-service:latest"
      port  = 8082
      cpu   = 512
      memory = 1024
    }
  }
}

# Shared ECS Cluster
module "ecs_cluster" {
  source = "git::https://github.com/basil9242/AWS_terraform_modules.git//ECS"
  
  cluster_name             = "microservices-cluster"
  enable_container_insights = true
  create_service           = false  # Only create cluster
  
  tags = {
    Environment = "production"
    Architecture = "microservices"
  }
}

# Individual Microservices
module "microservices" {
  source = "git::https://github.com/basil9242/AWS_terraform_modules.git//ECS"
  
  for_each = local.microservices
  
  # Use existing cluster
  cluster_name = module.ecs_cluster.cluster_name
  
  # Service Configuration
  service_name  = each.key
  desired_count = 2
  launch_type   = "FARGATE"
  
  # Network
  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnet_ids
  
  # Task Definition
  task_definition_family = each.key
  task_cpu              = tostring(each.value.cpu)
  task_memory           = tostring(each.value.memory)
  
  # Container
  container_name  = each.key
  container_image = each.value.image
  container_port  = each.value.port
  
  # Service Discovery
  enable_service_discovery         = true
  service_discovery_namespace_id   = var.service_discovery_namespace_id
  service_discovery_service_name   = each.key
  
  # Auto Scaling
  enable_autoscaling      = true
  autoscaling_min_capacity = 1
  autoscaling_max_capacity = 10
  
  tags = {
    Service     = each.key
    Environment = "production"
  }
  
  depends_on = [module.ecs_cluster]
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| aws | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| aws | ~> 5.0 |

## Resources Created

| Resource | Description |
|----------|-------------|
| `aws_ecs_cluster` | ECS cluster with optional Container Insights |
| `aws_ecs_cluster_capacity_providers` | Capacity providers for the cluster |
| `aws_ecs_service` | ECS service with deployment configuration |
| `aws_ecs_task_definition` | Task definition with container specifications |
| `aws_iam_role` | IAM roles for execution, task, and autoscaling |
| `aws_iam_role_policy` | Custom IAM policies |
| `aws_iam_role_policy_attachment` | Managed policy attachments |
| `aws_security_group` | Security group for ECS service |
| `aws_vpc_security_group_ingress_rule` | Security group ingress rules |
| `aws_vpc_security_group_egress_rule` | Security group egress rules |
| `aws_cloudwatch_log_group` | CloudWatch log groups for tasks and exec |
| `aws_cloudwatch_log_metric_filter` | Metric filters for error monitoring |
| `aws_cloudwatch_metric_alarm` | CloudWatch alarms for monitoring |
| `aws_appautoscaling_target` | Auto scaling target |
| `aws_appautoscaling_policy` | Auto scaling policies |
| `aws_appautoscaling_scheduled_action` | Scheduled scaling actions |
| `aws_service_discovery_private_dns_namespace` | Service discovery namespace |
| `aws_service_discovery_service` | Service discovery service |
| `aws_kms_key` | KMS key for encryption |
| `aws_kms_key_policy` | KMS key policy |
| `aws_kms_alias` | KMS key alias |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `cluster_name` | Name of the ECS cluster | `string` | n/a | yes |
| `service_name` | Name of the ECS service | `string` | `""` | no |
| `create_service` | Whether to create an ECS service | `bool` | `true` | no |
| `desired_count` | Desired number of tasks | `number` | `1` | no |
| `launch_type` | Launch type (FARGATE, EC2, or null) | `string` | `"FARGATE"` | no |
| `vpc_id` | VPC ID where resources will be created | `string` | `""` | no |
| `subnet_ids` | List of subnet IDs for the service | `list(string)` | `[]` | no |
| `task_definition_family` | Family name for the task definition | `string` | `""` | no |
| `task_cpu` | CPU units for the task | `string` | `"256"` | no |
| `task_memory` | Memory for the task | `string` | `"512"` | no |
| `container_name` | Name of the container | `string` | `""` | no |
| `container_image` | Docker image for the container | `string` | `""` | no |
| `container_port` | Port exposed by the container | `number` | `80` | no |
| `enable_autoscaling` | Whether to enable auto scaling | `bool` | `false` | no |
| `enable_service_discovery` | Whether to enable service discovery | `bool` | `false` | no |
| `enable_load_balancer` | Whether to enable load balancer integration | `bool` | `false` | no |
| `enable_container_insights` | Whether to enable Container Insights | `bool` | `true` | no |
| `enable_execute_command` | Whether to enable ECS Exec | `bool` | `false` | no |
| `tags` | Resource tags | `map(string)` | `{}` | no |
| `environment` | Environment name | `string` | `"dev"` | no |

*Note: This is a subset of inputs. See variables.tf for the complete list.*

## Outputs

| Name | Description |
|------|-------------|
| `cluster_id` | ID of the ECS cluster |
| `cluster_arn` | ARN of the ECS cluster |
| `cluster_name` | Name of the ECS cluster |
| `service_id` | ID of the ECS service |
| `service_arn` | ARN of the ECS service |
| `service_name` | Name of the ECS service |
| `task_definition_arn` | ARN of the task definition |
| `execution_role_arn` | ARN of the ECS execution role |
| `task_role_arn` | ARN of the ECS task role |
| `security_group_id` | ID of the ECS service security group |
| `log_group_name` | Name of the CloudWatch log group |
| `kms_key_arn` | ARN of the KMS key |

*Note: See outputs.tf for the complete list of outputs.*

## Examples

### Web Application with Database

```hcl
module "web_app_ecs" {
  source = "git::https://github.com/basil9242/AWS_terraform_modules.git//ECS"
  
  cluster_name = "web-app-cluster"
  service_name = "web-app"
  
  # Task Configuration
  task_definition_family = "web-app"
  task_cpu              = "512"
  task_memory           = "1024"
  
  # Container Configuration
  container_name  = "web-app"
  container_image = "my-web-app:latest"
  container_port  = 3000
  
  # Environment Variables
  environment_variables = {
    NODE_ENV = "production"
    PORT     = "3000"
  }
  
  # Database Connection Secret
  secrets = [
    {
      name      = "DATABASE_URL"
      valueFrom = aws_secretsmanager_secret.db_connection.arn
    }
  ]
  
  # Network Configuration
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnet_ids
  
  # Load Balancer
  enable_load_balancer = true
  target_group_arn     = aws_lb_target_group.web_app.arn
  
  # Auto Scaling
  enable_autoscaling      = true
  autoscaling_min_capacity = 2
  autoscaling_max_capacity = 10
  cpu_target_value        = 70
  
  # Health Check
  enable_health_check   = true
  health_check_command  = ["CMD-SHELL", "curl -f http://localhost:3000/health || exit 1"]
  
  tags = {
    Application = "web-app"
    Tier        = "application"
  }
}
```

### Batch Processing Service

```hcl
module "batch_processor" {
  source = "git::https://github.com/basil9242/AWS_terraform_modules.git//ECS"
  
  cluster_name = "batch-processing-cluster"
  service_name = "batch-processor"
  
  # Use Spot instances for cost optimization
  enable_capacity_providers = true
  capacity_providers       = ["FARGATE_SPOT"]
  
  # Task Configuration
  task_definition_family = "batch-processor"
  task_cpu              = "2048"
  task_memory           = "4096"
  
  # Container Configuration
  container_name  = "processor"
  container_image = "my-batch-processor:latest"
  
  # Environment Variables
  environment_variables = {
    BATCH_SIZE    = "100"
    WORKER_THREADS = "4"
  }
  
  # IAM Permissions for S3 and SQS
  create_task_role = true
  task_role_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/AmazonSQSFullAccess"
  ]
  
  # Scheduled Scaling (scale up during business hours)
  enable_scheduled_scaling = true
  scheduled_scaling_actions = [
    {
      name         = "scale-up-business-hours"
      schedule     = "cron(0 9 * * MON-FRI)"
      min_capacity = 5
      max_capacity = 20
    },
    {
      name         = "scale-down-off-hours"
      schedule     = "cron(0 18 * * MON-FRI)"
      min_capacity = 1
      max_capacity = 5
    }
  ]
  
  tags = {
    Application = "batch-processor"
    CostOptimized = "true"
  }
}
```

### Multi-Container Task (Sidecar Pattern)

```hcl
# Note: This example shows how to extend the module for multi-container tasks
# You would need to modify the task_definition.tf to support multiple containers

module "app_with_sidecar" {
  source = "git::https://github.com/basil9242/AWS_terraform_modules.git//ECS"
  
  cluster_name = "sidecar-cluster"
  service_name = "app-with-logging"
  
  # Task Configuration
  task_definition_family = "app-with-sidecar"
  task_cpu              = "1024"
  task_memory           = "2048"
  
  # Main Container
  container_name  = "main-app"
  container_image = "my-app:latest"
  container_port  = 8080
  
  # Shared Volume for Logs
  volumes = [
    {
      name = "log-volume"
    }
  ]
  
  mount_points = [
    {
      sourceVolume  = "log-volume"
      containerPath = "/var/log/app"
      readOnly      = false
    }
  ]
  
  # Service Discovery
  enable_service_discovery         = true
  service_discovery_namespace_id   = aws_service_discovery_private_dns_namespace.main.id
  service_discovery_service_name   = "main-app"
  
  tags = {
    Pattern = "sidecar"
    Application = "main-app"
  }
}
```

## Best Practices

1. **Use Fargate for Simplicity** - Fargate removes the need to manage EC2 instances
2. **Enable Container Insights** - Get detailed metrics and logs for your containers
3. **Implement Health Checks** - Ensure your containers are healthy and responsive
4. **Use Service Discovery** - Enable service-to-service communication
5. **Enable Auto Scaling** - Handle variable workloads efficiently
6. **Secure with IAM Roles** - Use task roles for AWS service access
7. **Monitor with CloudWatch** - Set up alarms for key metrics
8. **Use Secrets Manager** - Store sensitive configuration securely
9. **Implement Circuit Breakers** - Enable deployment circuit breakers for safety
10. **Tag Resources** - Proper tagging for cost allocation and management

## Security Considerations

- All logs are encrypted with KMS by default
- IAM roles follow least privilege principle
- Security groups restrict network access
- ECS Exec is disabled by default (enable only when needed)
- Secrets are managed through AWS Secrets Manager
- Container images should be scanned for vulnerabilities

## Cost Optimization

- Use Fargate Spot for non-critical workloads
- Implement auto scaling to match demand
- Use appropriate CPU and memory allocations
- Consider scheduled scaling for predictable workloads
- Monitor and optimize resource utilization
- Use capacity providers for mixed instance types

## Monitoring and Troubleshooting

### Key Metrics to Monitor
- CPU and memory utilization
- Task count and service health
- Application-specific metrics
- Error rates and response times

### Troubleshooting Commands

```bash
# List ECS clusters
aws ecs list-clusters

# Describe ECS service
aws ecs describe-services --cluster my-cluster --services my-service

# List running tasks
aws ecs list-tasks --cluster my-cluster --service-name my-service

# Get task logs
aws logs get-log-events --log-group-name /ecs/my-cluster/my-service --log-stream-name ecs/my-container/task-id

# Execute command in running container (if ECS Exec is enabled)
aws ecs execute-command --cluster my-cluster --task task-id --container my-container --interactive --command "/bin/bash"

# Check auto scaling activities
aws application-autoscaling describe-scaling-activities --service-namespace ecs
```

### Common Issues

1. **Task startup failures** - Check task definition and container health
2. **Service not reaching steady state** - Verify health checks and deployment configuration
3. **Auto scaling not working** - Check CloudWatch metrics and scaling policies
4. **Service discovery issues** - Verify namespace and service configuration
5. **Permission errors** - Review IAM roles and policies

## Integration Examples

### With Application Load Balancer

```hcl
# ALB Target Group
resource "aws_lb_target_group" "ecs_targets" {
  name     = "ecs-targets"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  
  health_check {
    enabled             = true
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    path                = "/health"
    matcher             = "200"
  }
}

# ECS Service with ALB
module "ecs_with_alb" {
  source = "git::https://github.com/basil9242/AWS_terraform_modules.git//ECS"
  
  # ... other configuration ...
  
  enable_load_balancer = true
  target_group_arn     = aws_lb_target_group.ecs_targets.arn
  
  # Enable request-based auto scaling
  enable_request_scaling        = true
  request_count_target_value    = 1000
  alb_resource_label           = aws_lb_target_group.ecs_targets.arn_suffix
}
```

### With RDS Database

```hcl
# Database connection secret
resource "aws_secretsmanager_secret" "db_connection" {
  name = "ecs-db-connection"
}

resource "aws_secretsmanager_secret_version" "db_connection" {
  secret_id = aws_secretsmanager_secret.db_connection.id
  secret_string = jsonencode({
    host     = aws_db_instance.main.endpoint
    port     = aws_db_instance.main.port
    username = aws_db_instance.main.username
    password = aws_db_instance.main.password
    database = aws_db_instance.main.db_name
  })
}

# ECS Service with database access
module "ecs_with_db" {
  source = "git::https://github.com/basil9242/AWS_terraform_modules.git//ECS"
  
  # ... other configuration ...
  
  secrets = [
    {
      name      = "DATABASE_CONFIG"
      valueFrom = aws_secretsmanager_secret.db_connection.arn
    }
  ]
  
  secrets_manager_arns = [
    "${aws_secretsmanager_secret.db_connection.arn}*"
  ]
}
```

## License

This module is released under the MIT License. See LICENSE file for details.