# Example 1: Basic DevOps Agent deployment
module "devopsagent_basic" {
  source = "./"

  agent_space_name    = "my-devops-agent"
  aws_region          = var.aws_region
  service_account_id  = data.aws_caller_identity.current.account_id

  tags = {
    Environment = "production"
    Project     = "devops"
    ManagedBy   = "terraform"
  }
}

# Example 2: DevOps Agent with custom language preference
module "devopsagent_multilang" {
  source = "./"

  agent_space_name        = "multi-lang-agent"
  aws_region              = var.aws_region
  service_account_id      = data.aws_caller_identity.current.account_id
  agent_response_language = "es-ES"  # Spanish responses

  tags = {
    Environment = "staging"
    Language    = "Spanish"
    ManagedBy   = "terraform"
  }
}

# Data source to get current AWS account ID
data "aws_caller_identity" "current" {}

# Outputs for reference
output "agent_space_basic" {
  description = "Basic DevOps Agent Space details"
  value       = module.devopsagent_basic
}

output "agent_space_multilang" {
  description = "Multi-language DevOps Agent Space details"
  value       = module.devopsagent_multilang
}
