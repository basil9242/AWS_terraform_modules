# Cluster Configuration
variable "cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
  validation {
    condition     = length(var.cluster_name) > 0 && length(var.cluster_name) <= 255
    error_message = "Cluster name must be between 1 and 255 characters."
  }
}

variable "enable_container_insights" {
  description = "Whether to enable CloudWatch Container Insights"
  type        = bool
  default     = true
}

variable "enable_execute_command" {
  description = "Whether to enable ECS Exec for debugging"
  type        = bool
  default     = false
}

# Capacity Providers
variable "enable_capacity_providers" {
  description = "Whether to enable capacity providers"
  type        = bool
  default     = false
}

variable "capacity_providers" {
  description = "List of capacity providers to associate with the cluster"
  type        = list(string)
  default     = ["FARGATE", "FARGATE_SPOT"]
}

variable "default_capacity_provider_strategy" {
  description = "Default capacity provider strategy for the cluster"
  type = list(object({
    capacity_provider = string
    weight           = number
    base             = number
  }))
  default = []
}

# Service Configuration
variable "create_service" {
  description = "Whether to create an ECS service"
  type        = bool
  default     = true
}

variable "service_name" {
  description = "Name of the ECS service"
  type        = string
  default     = ""
}

variable "desired_count" {
  description = "Desired number of tasks"
  type        = number
  default     = 1
  validation {
    condition     = var.desired_count >= 0
    error_message = "Desired count must be a non-negative number."
  }
}

variable "launch_type" {
  description = "Launch type for the service (FARGATE, EC2, or null for capacity providers)"
  type        = string
  default     = "FARGATE"
  validation {
    condition     = var.launch_type == null || contains(["FARGATE", "EC2"], var.launch_type)
    error_message = "Launch type must be FARGATE, EC2, or null."
  }
}

# Network Configuration
variable "subnet_ids" {
  description = "List of subnet IDs for the service"
  type        = list(string)
  default     = []
}

variable "vpc_id" {
  description = "VPC ID where resources will be created"
  type        = string
  default     = ""
}

variable "assign_public_ip" {
  description = "Whether to assign a public IP to tasks"
  type        = bool
  default     = false
}

# Task Definition Configuration
variable "task_definition_family" {
  description = "Family name for the task definition"
  type        = string
  default     = ""
}

variable "network_mode" {
  description = "Network mode for the task definition"
  type        = string
  default     = "awsvpc"
  validation {
    condition     = contains(["none", "bridge", "awsvpc", "host"], var.network_mode)
    error_message = "Network mode must be one of: none, bridge, awsvpc, host."
  }
}

variable "requires_compatibilities" {
  description = "Set of launch types required by the task"
  type        = list(string)
  default     = ["FARGATE"]
}

variable "task_cpu" {
  description = "CPU units for the task"
  type        = string
  default     = "256"
}

variable "task_memory" {
  description = "Memory for the task"
  type        = string
  default     = "512"
}

# Container Configuration
variable "container_name" {
  description = "Name of the container"
  type        = string
  default     = ""
}

variable "container_image" {
  description = "Docker image for the container"
  type        = string
  default     = ""
}

variable "container_cpu" {
  description = "CPU units for the container"
  type        = number
  default     = 256
}

variable "container_memory" {
  description = "Memory for the container"
  type        = number
  default     = 512
}

variable "container_port" {
  description = "Port exposed by the container"
  type        = number
  default     = 80
}

variable "environment_variables" {
  description = "Environment variables for the container"
  type        = map(string)
  default     = {}
}

variable "secrets" {
  description = "Secrets for the container"
  type = list(object({
    name      = string
    valueFrom = string
  }))
  default = []
}

# Health Check Configuration
variable "enable_health_check" {
  description = "Whether to enable container health checks"
  type        = bool
  default     = false
}

variable "health_check_command" {
  description = "Health check command"
  type        = list(string)
  default     = ["CMD-SHELL", "curl -f http://localhost/ || exit 1"]
}

variable "health_check_interval" {
  description = "Health check interval in seconds"
  type        = number
  default     = 30
}

variable "health_check_timeout" {
  description = "Health check timeout in seconds"
  type        = number
  default     = 5
}

variable "health_check_retries" {
  description = "Number of health check retries"
  type        = number
  default     = 3
}

variable "health_check_start_period" {
  description = "Health check start period in seconds"
  type        = number
  default     = 60
}

# Load Balancer Configuration
variable "enable_load_balancer" {
  description = "Whether to enable load balancer integration"
  type        = bool
  default     = false
}

variable "target_group_arn" {
  description = "ARN of the target group for load balancer"
  type        = string
  default     = ""
}

# Security Group Configuration
variable "create_security_group" {
  description = "Whether to create a security group for the service"
  type        = bool
  default     = true
}

variable "existing_security_group_ids" {
  description = "List of existing security group IDs to use (when create_security_group is false)"
  type        = list(string)
  default     = []
}

variable "security_group_ingress_rules" {
  description = "List of ingress rules for the security group"
  type = list(object({
    from_port   = number
    to_port     = number
    ip_protocol = string
    cidr_ipv4   = string
    description = string
  }))
  default = []
}

variable "security_group_egress_rules" {
  description = "List of egress rules for the security group"
  type = list(object({
    from_port   = number
    to_port     = number
    ip_protocol = string
    cidr_ipv4   = string
    description = string
  }))
  default = []
}

variable "allow_all_egress" {
  description = "Whether to allow all outbound traffic"
  type        = bool
  default     = true
}

# IAM Configuration
variable "create_task_role" {
  description = "Whether to create a task role"
  type        = bool
  default     = false
}

variable "task_role_policy_json" {
  description = "JSON policy for the task role"
  type        = string
  default     = null
}

variable "task_role_policy_arns" {
  description = "List of policy ARNs to attach to the task role"
  type        = list(string)
  default     = []
}

variable "secrets_manager_arns" {
  description = "List of Secrets Manager ARNs that the task can access"
  type        = list(string)
  default     = []
}

variable "ssm_parameter_arns" {
  description = "List of SSM Parameter ARNs that the task can access"
  type        = list(string)
  default     = []
}

# Logging Configuration
variable "log_retention_days" {
  description = "CloudWatch log retention period in days"
  type        = number
  default     = 7
  validation {
    condition = contains([
      1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1096, 1827, 2192, 2557, 2922, 3288, 3653
    ], var.log_retention_days)
    error_message = "Log retention days must be a valid CloudWatch Logs retention value."
  }
}

# Auto Scaling Configuration
variable "enable_autoscaling" {
  description = "Whether to enable auto scaling"
  type        = bool
  default     = false
}

variable "autoscaling_min_capacity" {
  description = "Minimum number of tasks"
  type        = number
  default     = 1
}

variable "autoscaling_max_capacity" {
  description = "Maximum number of tasks"
  type        = number
  default     = 10
}

variable "enable_cpu_scaling" {
  description = "Whether to enable CPU-based scaling"
  type        = bool
  default     = true
}

variable "enable_memory_scaling" {
  description = "Whether to enable memory-based scaling"
  type        = bool
  default     = true
}

variable "enable_request_scaling" {
  description = "Whether to enable request count-based scaling"
  type        = bool
  default     = false
}

variable "cpu_target_value" {
  description = "Target CPU utilization percentage"
  type        = number
  default     = 70
}

variable "memory_target_value" {
  description = "Target memory utilization percentage"
  type        = number
  default     = 80
}

variable "request_count_target_value" {
  description = "Target request count per target"
  type        = number
  default     = 1000
}

variable "scale_in_cooldown" {
  description = "Scale in cooldown period in seconds"
  type        = number
  default     = 300
}

variable "scale_out_cooldown" {
  description = "Scale out cooldown period in seconds"
  type        = number
  default     = 300
}

variable "alb_resource_label" {
  description = "ALB resource label for request count scaling"
  type        = string
  default     = ""
}

# Scheduled Scaling
variable "enable_scheduled_scaling" {
  description = "Whether to enable scheduled scaling"
  type        = bool
  default     = false
}

variable "scheduled_scaling_actions" {
  description = "List of scheduled scaling actions"
  type = list(object({
    name         = string
    schedule     = string
    min_capacity = number
    max_capacity = number
  }))
  default = []
}

# Service Discovery Configuration
variable "enable_service_discovery" {
  description = "Whether to enable service discovery"
  type        = bool
  default     = false
}

variable "create_service_discovery_namespace" {
  description = "Whether to create a service discovery namespace"
  type        = bool
  default     = false
}

variable "service_discovery_namespace_name" {
  description = "Name of the service discovery namespace"
  type        = string
  default     = ""
}

variable "service_discovery_namespace_id" {
  description = "ID of existing service discovery namespace"
  type        = string
  default     = ""
}

variable "service_discovery_service_name" {
  description = "Name of the service discovery service"
  type        = string
  default     = ""
}

variable "service_discovery_dns_ttl" {
  description = "DNS TTL for service discovery"
  type        = number
  default     = 60
}

variable "service_discovery_dns_type" {
  description = "DNS record type for service discovery"
  type        = string
  default     = "A"
}

variable "service_discovery_routing_policy" {
  description = "Routing policy for service discovery"
  type        = string
  default     = "MULTIVALUE"
}

variable "service_discovery_health_check_grace_period" {
  description = "Health check grace period for service discovery"
  type        = number
  default     = null
}

variable "service_discovery_failure_threshold" {
  description = "Failure threshold for service discovery health checks"
  type        = number
  default     = 1
}

# Deployment Configuration
variable "deployment_maximum_percent" {
  description = "Maximum percentage of tasks that can be running during deployment"
  type        = number
  default     = 200
}

variable "deployment_minimum_healthy_percent" {
  description = "Minimum percentage of tasks that must remain healthy during deployment"
  type        = number
  default     = 100
}

variable "enable_deployment_circuit_breaker" {
  description = "Whether to enable deployment circuit breaker"
  type        = bool
  default     = true
}

variable "enable_deployment_rollback" {
  description = "Whether to enable automatic rollback on deployment failure"
  type        = bool
  default     = true
}

variable "deployment_controller_type" {
  description = "Type of deployment controller (ECS, CODE_DEPLOY, EXTERNAL)"
  type        = string
  default     = null
  validation {
    condition     = var.deployment_controller_type == null || contains(["ECS", "CODE_DEPLOY", "EXTERNAL"], var.deployment_controller_type)
    error_message = "Deployment controller type must be one of: ECS, CODE_DEPLOY, EXTERNAL."
  }
}



# Capacity Provider Strategy
variable "capacity_provider_strategy" {
  description = "Capacity provider strategy for the service"
  type = list(object({
    capacity_provider = string
    weight           = number
    base             = number
  }))
  default = []
}

# Volume Configuration
variable "volumes" {
  description = "List of volumes for the task definition"
  type = list(object({
    name      = string
    host_path = optional(string)
    docker_volume_configuration = optional(object({
      scope         = string
      autoprovision = bool
      driver        = string
      driver_opts   = map(string)
      labels        = map(string)
    }))
    efs_volume_configuration = optional(object({
      file_system_id          = string
      root_directory          = string
      transit_encryption      = string
      transit_encryption_port = number
      authorization_config = optional(object({
        access_point_id = string
        iam             = string
      }))
    }))
    fsx_windows_file_server_volume_configuration = optional(object({
      file_system_id = string
      root_directory = string
      authorization_config = object({
        credentials_parameter = string
        domain               = string
      })
    }))
  }))
  default = []
}

variable "mount_points" {
  description = "Mount points for the container"
  type = list(object({
    sourceVolume  = string
    containerPath = string
    readOnly      = bool
  }))
  default = []
}

variable "volumes_from" {
  description = "Volumes to mount from other containers"
  type = list(object({
    sourceContainer = string
    readOnly        = bool
  }))
  default = []
}

# Linux Parameters
variable "enable_linux_parameters" {
  description = "Whether to enable Linux parameters"
  type        = bool
  default     = false
}

variable "linux_capabilities_add" {
  description = "Linux capabilities to add"
  type        = list(string)
  default     = []
}

variable "linux_capabilities_drop" {
  description = "Linux capabilities to drop"
  type        = list(string)
  default     = []
}

variable "linux_devices" {
  description = "Linux devices"
  type = list(object({
    hostPath      = string
    containerPath = string
    permissions   = list(string)
  }))
  default = []
}

variable "init_process_enabled" {
  description = "Whether to enable init process"
  type        = bool
  default     = false
}

variable "max_swap" {
  description = "Maximum swap space in MiB"
  type        = number
  default     = null
}

variable "shared_memory_size" {
  description = "Shared memory size in MiB"
  type        = number
  default     = null
}

variable "swappiness" {
  description = "Swappiness value (0-100)"
  type        = number
  default     = null
}

variable "tmpfs" {
  description = "Tmpfs mount points"
  type = list(object({
    containerPath = string
    size          = number
    mountOptions  = list(string)
  }))
  default = []
}

# Container Configuration
variable "ulimits" {
  description = "Ulimits for the container"
  type = list(object({
    name      = string
    softLimit = number
    hardLimit = number
  }))
  default = []
}

variable "docker_labels" {
  description = "Docker labels for the container"
  type        = map(string)
  default     = {}
}

variable "container_depends_on" {
  description = "Container dependencies"
  type = list(object({
    containerName = string
    condition     = string
  }))
  default = []
}

# Placement Constraints
variable "placement_constraints" {
  description = "Placement constraints for the task"
  type = list(object({
    type       = string
    expression = string
  }))
  default = []
}

# Proxy Configuration
variable "proxy_configuration" {
  description = "Proxy configuration for the task"
  type = object({
    type           = string
    container_name = string
    properties     = map(string)
  })
  default = null
}

# Inference Accelerators
variable "inference_accelerators" {
  description = "Inference accelerators for the task"
  type = list(object({
    device_name = string
    device_type = string
  }))
  default = []
}

# Monitoring Configuration
variable "enable_cloudwatch_alarms" {
  description = "Whether to enable CloudWatch alarms"
  type        = bool
  default     = false
}

variable "enable_error_monitoring" {
  description = "Whether to enable error monitoring with metric filters"
  type        = bool
  default     = false
}

variable "cpu_alarm_threshold" {
  description = "CPU utilization threshold for alarms"
  type        = number
  default     = 80
}

variable "memory_alarm_threshold" {
  description = "Memory utilization threshold for alarms"
  type        = number
  default     = 80
}

variable "alarm_actions" {
  description = "List of alarm actions (SNS topic ARNs)"
  type        = list(string)
  default     = []
}

# KMS Configuration
variable "enable_kms_key_rotation" {
  description = "Whether to enable automatic KMS key rotation"
  type        = bool
  default     = true
}

variable "kms_key_deletion_window" {
  description = "KMS key deletion window in days"
  type        = number
  default     = 20
  validation {
    condition     = var.kms_key_deletion_window >= 7 && var.kms_key_deletion_window <= 30
    error_message = "KMS key deletion window must be between 7 and 30 days."
  }
}

# Tagging
variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
  default     = {}
}

variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"
}