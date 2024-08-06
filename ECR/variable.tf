variable "ecr_name" {
  description = "Name of the repository"
  type        = string
  default     = null
}

variable "ecr_image_tag_mutability" {
  description = "The tag mutability setting for the repository. Must be one of: MUTABLE or IMMUTABLE."
  type        = string
  default     = "IMMUTABLE"
}

variable "ecr_repository_policy_requried" {
  description = "ECR repository policy is requried not not"
  type        = bool
  default     = false
}

variable "ecr_policy_json_file" {
  description = "ECR policy json file path"
  type        = string
  default     = null
}