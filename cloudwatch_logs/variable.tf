variable "cloudwatch_log_group_name" {
  description = "CloudWatch log group name"
  type        = string
  validation {
    condition     = var.cloudwatch_log_group_name != null && length(var.cloudwatch_log_group_name) > 0
    error_message = "CloudWatch log group name must be provided and cannot be empty."
  }
}

variable "log_group_skip_destroy" {
  description = "Set to true if you do not wish the log group (and any logs it may contain) to be deleted at destroy time, and instead just remove the log group from the Terraform state."
  type        = bool
  default     = false
}

variable "log_group_class" {
  description = "Specified the log class of the log group. Possible values are: STANDARD or INFREQUENT_ACCESS."
  type        = string
  default     = "STANDARD"
}

variable "logs_retention_in_days" {
  description = "Specifies the number of days you want to retain log events in the specified log group."
  type        = number
  default     = 7
  validation {
    condition = contains([
      1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1096, 1827, 2192, 2557, 2922, 3288, 3653
    ], var.logs_retention_in_days)
    error_message = "Retention period must be one of the valid CloudWatch Logs retention values."
  }
}

variable "cloudwatch_log_subscription_filter_required" {
  description = "Whether CloudWatch log subscription filter is required"
  type        = bool
  default     = false
}

variable "cloudwatch_log_filter" {
  description = "A valid CloudWatch Logs filter pattern for subscribing to a filtered stream of log events"
  type        = string
  default     = null
}

variable "destination_arn_push_logs" {
  description = "The ARN of the destination to deliver matching log events to (Lambda function ARN, Kinesis stream, etc.)"
  type        = string
  default     = null
}

variable "kms_key_deletion_window" {
  description = "The waiting period, specified in number of days, after which the KMS key is deleted"
  type        = number
  default     = 20
  validation {
    condition     = var.kms_key_deletion_window >= 7 && var.kms_key_deletion_window <= 30
    error_message = "KMS key deletion window must be between 7 and 30 days."
  }
}

variable "enable_kms_key_rotation" {
  description = "Whether to enable automatic KMS key rotation"
  type        = bool
  default     = true
}

variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
  default     = {}
}

# Log Stream Configuration
variable "create_log_streams" {
  description = "Whether to create log streams within the log group"
  type        = bool
  default     = false
}

variable "log_streams" {
  description = "List of log stream names to create"
  type        = list(string)
  default     = []
}

# Metric Filter Configuration
variable "create_metric_filters" {
  description = "Whether to create CloudWatch metric filters"
  type        = bool
  default     = false
}

variable "metric_filters" {
  description = "List of metric filter configurations"
  type = list(object({
    name             = string
    pattern          = string
    metric_name      = string
    metric_namespace = string
    metric_value     = optional(string, "1")
    default_value    = optional(number, null)
  }))
  default = []
}

# Log Destination Configuration
variable "create_log_destination" {
  description = "Whether to create a log destination for cross-account log sharing"
  type        = bool
  default     = false
}

variable "log_destination_name" {
  description = "Name for the log destination"
  type        = string
  default     = null
}

variable "log_destination_role_arn" {
  description = "ARN of the IAM role for the log destination"
  type        = string
  default     = null
}

variable "log_destination_target_arn" {
  description = "ARN of the target for the log destination (Kinesis stream, etc.)"
  type        = string
  default     = null
}

# Environment and naming
variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "default"
}
