variable "bucket_name" {
  description = "Name of the bucket"
  type        = string
  validation {
    condition     = length(var.bucket_name) > 0 && length(var.bucket_name) <= 63
    error_message = "Bucket name must be between 1 and 63 characters long."
  }
}

variable "bucket_object_destroy" {
  description = "Boolean that indicates all objects (including any locked objects) should be deleted from the bucket when the bucket is destroyed so that the bucket can be destroyed without error"
  type        = bool
  default     = false
}

variable "bucket_acl" {
  description = "Amazon S3 access control lists (ACLs) enable you to manage access to buckets and objects. Valid values are private, public-read, public-read-write, aws-exec-read, authenticated-read, and log-delivery-write"
  type        = string
  default     = "private-read"
}

variable "s3_bucket_website_configuration_required" {
  description = "Whether S3 bucket website configuration resource is required"
  type        = bool
  default     = false
}

variable "s3_website_index_document" {
  description = "Name of the index document for the website"
  type        = string
  default     = "index.html"
}

variable "s3_website_error_document" {
  description = "Name of the error document for the website."
  type        = string
  default     = "error.html"
}

variable "s3_bucket_versioning" {
  description = "Configuration block for the versioning parameters. Values are Enabled, Disabled"
  type        = string
  default     = "Enabled"
  validation {
    condition     = contains(["Enabled", "Disabled", "Suspended"], var.s3_bucket_versioning)
    error_message = "S3 bucket versioning must be one of: Enabled, Disabled, Suspended."
  }
}

variable "s3_bucket_policy_required" {
  description = "Whether to apply the policy to bucket"
  type        = bool
  default     = false
}

variable "s3_bucket_policy_json_file_path" {
  description = "bucket policy file path"
  type        = string
  default     = null
}

variable "s3_block_public_acls" {
  description = "Whether Amazon S3 should block public ACLs for this bucket"
  type        = bool
  default     = true
}

variable "s3_block_public_policy" {
  description = "Whether Amazon S3 should block public bucket policies for this bucket"
  type        = bool
  default     = true
}

variable "s3_restrict_public_buckets" {
  description = "Whether Amazon S3 should restrict public bucket policies for this bucket"
  type        = bool
  default     = true
}

variable "s3_ignore_public_acls" {
  description = "Whether Amazon S3 should ignore public ACLs for this bucket"
  type        = bool
  default     = true
}

# ACL Configuration
variable "enable_bucket_acl" {
  description = "Whether to enable bucket ACL"
  type        = bool
  default     = false
}

variable "object_ownership" {
  description = "Object ownership setting for the bucket"
  type        = string
  default     = "BucketOwnerPreferred"
  validation {
    condition     = contains(["BucketOwnerPreferred", "ObjectWriter", "BucketOwnerEnforced"], var.object_ownership)
    error_message = "Object ownership must be one of: BucketOwnerPreferred, ObjectWriter, BucketOwnerEnforced."
  }
}

# Lifecycle Configuration
variable "enable_lifecycle_configuration" {
  description = "Whether to enable lifecycle configuration"
  type        = bool
  default     = false
}

variable "lifecycle_rules" {
  description = "List of lifecycle rules"
  type = list(object({
    id     = string
    status = string
    expiration = optional(object({
      days                         = optional(number)
      date                         = optional(string)
      expired_object_delete_marker = optional(bool)
    }))
    noncurrent_version_expiration = optional(object({
      days = number
    }))
    transitions = optional(list(object({
      days          = optional(number)
      date          = optional(string)
      storage_class = string
    })))
    noncurrent_version_transitions = optional(list(object({
      days          = number
      storage_class = string
    })))
    filter = optional(object({
      prefix = optional(string)
      tags   = optional(map(string))
    }))
  }))
  default = []
}

# Logging Configuration
variable "enable_logging" {
  description = "Whether to enable access logging"
  type        = bool
  default     = false
}

variable "logging_target_bucket" {
  description = "Target bucket for access logs"
  type        = string
  default     = null
}

variable "logging_target_prefix" {
  description = "Prefix for access log objects"
  type        = string
  default     = "access-logs/"
}

variable "logging_target_grants" {
  description = "List of target grants for logging"
  type = list(object({
    grantee_id   = string
    grantee_type = string
    permission   = string
  }))
  default = []
}

# Notification Configuration
variable "enable_notifications" {
  description = "Whether to enable bucket notifications"
  type        = bool
  default     = false
}

variable "lambda_notifications" {
  description = "List of Lambda function notifications"
  type = list(object({
    function_arn  = string
    events        = list(string)
    filter_prefix = optional(string)
    filter_suffix = optional(string)
  }))
  default = []
}

variable "sns_notifications" {
  description = "List of SNS topic notifications"
  type = list(object({
    topic_arn     = string
    events        = list(string)
    filter_prefix = optional(string)
    filter_suffix = optional(string)
  }))
  default = []
}

variable "sqs_notifications" {
  description = "List of SQS queue notifications"
  type = list(object({
    queue_arn     = string
    events        = list(string)
    filter_prefix = optional(string)
    filter_suffix = optional(string)
  }))
  default = []
}

# CORS Configuration
variable "enable_cors" {
  description = "Whether to enable CORS configuration"
  type        = bool
  default     = false
}

variable "cors_rules" {
  description = "List of CORS rules"
  type = list(object({
    allowed_headers = optional(list(string))
    allowed_methods = list(string)
    allowed_origins = list(string)
    expose_headers  = optional(list(string))
    max_age_seconds = optional(number)
  }))
  default = []
}

# Tagging and Environment
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