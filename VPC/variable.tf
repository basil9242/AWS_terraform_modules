#VPC
variable "cidr_block_vpc" {
  description = "CIDR block for VPC"
  type        = string
  default     = ""
}

variable "vpc_instance_tenancy" {
  description = "A tenancy option for instances launched into the VPCu"
  type        = string
  default     = "default"
}

variable "vpc_name" {
  description = "VPC name"
  type        = string
  default     = ""
}

variable "enable_dns_hostnames" {
  description = "A boolean flag to enable/disable DNS hostnames in the VPC"
  type        = bool
  default     = false
}

#subnet
variable "public_subnet" {
  description = "cidr block, availability zone, name for public subnet"
  type = list(object({
    name              = string
    cidr_block        = string
    availability_zone = string
  }))
  default = [
    {
      name              = ""
      cidr_block        = ""
      availability_zone = ""
    }
  ]
}

variable "private_subnet" {
  description = "cidr block, availability zone, name for private subnet"
  type = list(object({
    name              = string
    cidr_block        = string
    availability_zone = string
  }))
  default = [
    {
      name              = ""
      cidr_block        = ""
      availability_zone = ""
    }
  ]
}

variable "vpc_cloudwatch_logs_group_name" {
  description = "vpc flow logs cloudwatch group name"
  type        = string
  default     = ""
}

variable "vpc_logs_role_name" {
  description = "VPC flow logs IAM role"
  type        = string
  default     = ""
}
# Gateway Configuration
variable "create_internet_gateway" {
  description = "Whether to create an Internet Gateway for the VPC"
  type        = bool
  default     = true
}

variable "create_nat_gateway" {
  description = "Whether to create NAT Gateways for private subnets"
  type        = bool
  default     = true
}

# DNS Configuration
variable "enable_dns_support" {
  description = "A boolean flag to enable/disable DNS support in the VPC"
  type        = bool
  default     = true
}

# VPC Flow Logs Configuration
variable "enable_flow_logs" {
  description = "Whether to enable VPC Flow Logs"
  type        = bool
  default     = true
}

variable "flow_logs_retention_days" {
  description = "Number of days to retain VPC Flow Logs"
  type        = number
  default     = 30
  validation {
    condition = contains([
      1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1096, 1827, 2192, 2557, 2922, 3288, 3653
    ], var.flow_logs_retention_days)
    error_message = "Flow logs retention period must be one of the valid CloudWatch Logs retention values."
  }
}

# Tagging
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
