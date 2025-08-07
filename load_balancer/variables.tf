variable "name" {
  description = "Name of the load balancer"
  type        = string
}

variable "internal" {
  description = "If true, the LB will be internal"
  type        = bool
  default     = false
}

variable "security_groups" {
  description = "A list of security group IDs to assign to the LB"
  type        = list(string)
}

variable "subnets" {
  description = "A list of subnet IDs to attach to the LB"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID where the load balancer will be created"
  type        = string
}

variable "enable_deletion_protection" {
  description = "If true, deletion of the load balancer will be disabled via the AWS API"
  type        = bool
  default     = false
}

variable "enable_http2" {
  description = "Indicates whether HTTP/2 is enabled in application load balancers"
  type        = bool
  default     = true
}

variable "enable_cross_zone_load_balancing" {
  description = "If true, cross-zone load balancing of the load balancer will be enabled"
  type        = bool
  default     = false
}

variable "access_logs_bucket" {
  description = "The S3 bucket name to store the logs in"
  type        = string
  default     = ""
}

variable "access_logs_prefix" {
  description = "The S3 bucket prefix"
  type        = string
  default     = ""
}

variable "access_logs_enabled" {
  description = "Boolean to enable / disable access_logs"
  type        = bool
  default     = false
}

variable "target_groups" {
  description = "List of target group configurations"
  type = list(object({
    name     = string
    port     = number
    protocol = string
    health_check = object({
      enabled             = bool
      healthy_threshold   = number
      interval            = number
      matcher             = string
      path                = string
      port                = string
      protocol            = string
      timeout             = number
      unhealthy_threshold = number
    })
    stickiness = object({
      type            = string
      cookie_duration = number
      enabled         = bool
    })
  }))
  default = [{
    name     = "default"
    port     = 80
    protocol = "HTTP"
    health_check = {
      enabled             = true
      healthy_threshold   = 2
      interval            = 30
      matcher             = "200"
      path                = "/"
      port                = "traffic-port"
      protocol            = "HTTP"
      timeout             = 5
      unhealthy_threshold = 2
    }
    stickiness = {
      type            = "lb_cookie"
      cookie_duration = 86400
      enabled         = false
    }
  }]
}

variable "enable_http_listener" {
  description = "Enable HTTP listener"
  type        = bool
  default     = true
}

variable "enable_https_listener" {
  description = "Enable HTTPS listener"
  type        = bool
  default     = false
}

variable "http_redirect_to_https" {
  description = "Redirect HTTP traffic to HTTPS"
  type        = bool
  default     = false
}

variable "ssl_policy" {
  description = "The name of the SSL Policy for the listener"
  type        = string
  default     = "ELBSecurityPolicy-TLS-1-2-2017-01"
}

variable "certificate_arn" {
  description = "The ARN of the default SSL server certificate"
  type        = string
  default     = ""
}

variable "listener_rules" {
  description = "List of listener rule configurations"
  type = list(object({
    listener_type = string
    priority      = number
    action = object({
      type                = string
      target_group_index  = number
      redirect = optional(object({
        host        = string
        path        = string
        port        = string
        protocol    = string
        query       = string
        status_code = string
      }))
      fixed_response = optional(object({
        content_type = string
        message_body = string
        status_code  = string
      }))
    })
    conditions = list(object({
      field             = string
      values            = list(string)
      http_header_name  = optional(string)
      query_string = optional(list(object({
        key   = string
        value = string
      })))
    }))
  }))
  default = []
}

variable "target_attachments" {
  description = "List of target attachments"
  type = list(object({
    target_group_index = number
    target_id          = string
    port               = number
  }))
  default = []
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}