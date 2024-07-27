variable "bucket_name" {
  description = "Name of the bucket"
  type        = string
  default     = ""
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

variable "s3_bucket_website_configuration_requried" {
  description = "S3 bucket website configuration resource requried or not"
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
  description = "Configuration block for the versioning parameters. Values are Enabled ,Disabled"
  type        = string
  default     = "Enabled"
}

variable "s3_bucket_policy_requried" {
  description = "apply the policy to bucket"
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