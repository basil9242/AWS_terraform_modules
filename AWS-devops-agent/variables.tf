variable "tags" {
    description = "Tags for services"
    type = map(string)
    default = {}
}

variable "aws_region" {
  description = "The AWS region to deploy resources"
  type        = string
  validation {
    condition = contains(["us-east-1","eu-central-1","us-west-2","ap-souteast-2","ap-souteast-1","eu-west-1"], var.aws_region)
    error_message = "aws region must be one of: us-east-1, eu-central-1, us-west-2, ap-souteast-2, ap-souteast-1, eu-west-1"
  }
  default     = null
}

variable "agent_space_name" {
    description = "The name of the AgentSpace"
    type        = string
    validation {
      condition     = length(var.agent_space_name) > 0
      error_message = "agent_space_name must not be empty"
    }
    default = null
}

variable "agent_response_language" {
    description = "The language for agent responses"
    type        = string
    validation {
      condition     = contains(["en-US", "en-GB", "fr-FR", "es-ES", "de-DE", "ja-JP", "zh-CN"], var.agent_response_language)
      error_message = "agent_response_language must be one of: en-US, en-GB, fr-FR, es-ES, de-DE, ja-JP, zh-CN"
    }
    default     = "en-US"
}
