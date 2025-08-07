variable "config_rule_name" {
  description = "Name of the AWS Config rule"
  type        = string
  default     = "s3-bucket-public-read-prohibited"
  
  validation {
    condition     = length(var.config_rule_name) > 0 && length(var.config_rule_name) <= 128
    error_message = "Config rule name must be between 1 and 128 characters."
  }
}

variable "config_rule_recorder_name" {
  description = "Name of the AWS Config rule recorder"
  type        = string
  default     = "s3-bucket-recorder"
  
  validation {
    condition     = length(var.config_rule_recorder_name) > 0
    error_message = "Config rule recorder name cannot be empty."
  }
}

variable "delivery_channel_name" {
  description = "Name of the delivery channel (only used if config_s3_bucket_name is provided)"
  type        = string
  default     = "s3-config-delivery-channel"
}

variable "config_s3_bucket_name" {
  description = "S3 bucket name for AWS Config delivery channel. If provided, a delivery channel will be created automatically."
  type        = string
  default     = ""
  
  validation {
    condition = var.config_s3_bucket_name == "" || can(regex("^[a-z0-9][a-z0-9.-]*[a-z0-9]$", var.config_s3_bucket_name))
    error_message = "S3 bucket name must be a valid bucket name or empty string."
  }
}

variable "config_s3_key_prefix" {
  description = "S3 key prefix for AWS Config delivery channel"
  type        = string
  default     = "config"
}

# SNS Configuration Variables
variable "create_sns_topic" {
  description = "Whether to create an SNS topic for Config notifications"
  type        = bool
  default     = false
}

variable "sns_topic_name" {
  description = "Name of the SNS topic for Config notifications (only used if create_sns_topic is true)"
  type        = string
  default     = "aws-config-s3-compliance-notifications"
}

variable "sns_topic_arn" {
  description = "ARN of existing SNS topic for Config notifications. If provided, this topic will be used instead of creating a new one."
  type        = string
  default     = ""
  
  validation {
    condition = var.sns_topic_arn == "" || can(regex("^arn:aws:sns:", var.sns_topic_arn))
    error_message = "SNS topic ARN must be a valid ARN or empty string."
  }
}

variable "enable_compliance_notifications" {
  description = "Whether to enable CloudWatch Events for compliance change notifications"
  type        = bool
  default     = false
}

variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
  default     = {}
}