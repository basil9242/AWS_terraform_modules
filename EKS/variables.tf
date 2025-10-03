variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  
  validation {
    condition     = length(var.cluster_name) > 0 && length(var.cluster_name) <= 100
    error_message = "Cluster name must be between 1 and 100 characters."
  }
}

variable "kubernetes_version" {
  description = "Kubernetes version to use for the EKS cluster"
  type        = string
  default     = "1.28"
  
  validation {
    condition     = can(regex("^1\\.(2[4-9]|[3-9][0-9])$", var.kubernetes_version))
    error_message = "Kubernetes version must be 1.24 or higher."
  }
}

variable "vpc_id" {
  description = "VPC ID where the cluster will be deployed"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the EKS cluster"
  type        = list(string)
  
  validation {
    condition     = length(var.subnet_ids) >= 2
    error_message = "At least 2 subnets are required for EKS cluster."
  }
}

variable "endpoint_private_access" {
  description = "Whether the Amazon EKS private API server endpoint is enabled"
  type        = bool
  default     = true
}

variable "endpoint_public_access" {
  description = "Whether the Amazon EKS public API server endpoint is enabled"
  type        = bool
  default     = false
}

variable "public_access_cidrs" {
  description = "List of CIDR blocks that can access the Amazon EKS public API server endpoint"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "additional_security_group_ids" {
  description = "List of additional security group IDs to attach to the EKS cluster"
  type        = list(string)
  default     = []
}

variable "enabled_cluster_log_types" {
  description = "List of control plane logging to enable"
  type        = list(string)
  default     = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  
  validation {
    condition = alltrue([
      for log_type in var.enabled_cluster_log_types : contains([
        "api", "audit", "authenticator", "controllerManager", "scheduler"
      ], log_type)
    ])
    error_message = "Invalid log type. Valid types are: api, audit, authenticator, controllerManager, scheduler."
  }
}

variable "log_retention_days" {
  description = "Number of days to retain log events"
  type        = number
  default     = 7
  
  validation {
    condition = contains([
      1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653
    ], var.log_retention_days)
    error_message = "Log retention days must be a valid CloudWatch Logs retention period."
  }
}

variable "kms_key_arn" {
  description = "ARN of the KMS key to use for encryption. If not provided, a new key will be created."
  type        = string
  default     = ""
}

# Node Groups Configuration
variable "node_groups" {
  description = "List of EKS node group configurations"
  type = list(object({
    name                       = string
    subnet_ids                 = list(string)
    capacity_type              = string
    instance_types             = list(string)
    ami_type                   = string
    disk_size                  = number
    desired_size               = number
    max_size                   = number
    min_size                   = number
    max_unavailable_percentage = number
  }))
  default = []
  
  validation {
    condition = alltrue([
      for ng in var.node_groups : contains(["ON_DEMAND", "SPOT"], ng.capacity_type)
    ])
    error_message = "Node group capacity_type must be either ON_DEMAND or SPOT."
  }
  
  validation {
    condition = alltrue([
      for ng in var.node_groups : contains([
        "AL2_x86_64", "AL2_x86_64_GPU", "AL2_ARM_64", "CUSTOM", "BOTTLEROCKET_ARM_64", "BOTTLEROCKET_x86_64"
      ], ng.ami_type)
    ])
    error_message = "Invalid AMI type specified."
  }
}

# Fargate Profiles Configuration
variable "fargate_profiles" {
  description = "List of EKS Fargate profile configurations"
  type = list(object({
    name       = string
    subnet_ids = list(string)
    selectors = list(object({
      namespace = string
      labels    = map(string)
    }))
  }))
  default = []
}

# EKS Add-ons Configuration
variable "cluster_addons" {
  description = "List of EKS cluster add-ons"
  type = list(object({
    name                     = string
    version                  = string
    resolve_conflicts        = string
    service_account_role_arn = string
  }))
  default = [
    {
      name                     = "vpc-cni"
      version                  = null
      resolve_conflicts        = "OVERWRITE"
      service_account_role_arn = null
    },
    {
      name                     = "coredns"
      version                  = null
      resolve_conflicts        = "OVERWRITE"
      service_account_role_arn = null
    },
    {
      name                     = "kube-proxy"
      version                  = null
      resolve_conflicts        = "OVERWRITE"
      service_account_role_arn = null
    }
  ]
}

# Security Group Configuration
variable "create_additional_security_group" {
  description = "Whether to create an additional security group for the EKS cluster"
  type        = bool
  default     = false
}

variable "additional_security_group_rules" {
  description = "Additional security group rules for the EKS cluster"
  type = object({
    ingress = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
      description = string
    }))
    egress = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
      description = string
    }))
  })
  default = {
    ingress = []
    egress = []
  }
}

# OIDC Configuration
variable "enable_irsa" {
  description = "Whether to create an OpenID Connect Provider for EKS to enable IRSA"
  type        = bool
  default     = true
}

# Encryption Configuration
variable "create_kms_key" {
  description = "Whether to create a KMS key for EKS encryption"
  type        = bool
  default     = true
}

variable "kms_key_deletion_window" {
  description = "The waiting period, specified in number of days, after which the KMS key is deleted"
  type        = number
  default     = 7
  
  validation {
    condition     = var.kms_key_deletion_window >= 7 && var.kms_key_deletion_window <= 30
    error_message = "KMS key deletion window must be between 7 and 30 days."
  }
}

# Tags
variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
  default     = {}
}

# Environment
variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"
}