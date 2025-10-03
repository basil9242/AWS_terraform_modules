output "cluster_id" {
  description = "The ID of the EKS cluster"
  value       = aws_eks_cluster.main.id
}

output "cluster_arn" {
  description = "The Amazon Resource Name (ARN) of the cluster"
  value       = aws_eks_cluster.main.arn
}

output "cluster_name" {
  description = "The name of the EKS cluster"
  value       = aws_eks_cluster.main.name
}

output "cluster_endpoint" {
  description = "Endpoint for your Kubernetes API server"
  value       = aws_eks_cluster.main.endpoint
}

output "cluster_version" {
  description = "The Kubernetes version for the cluster"
  value       = aws_eks_cluster.main.version
}

output "cluster_platform_version" {
  description = "Platform version for the cluster"
  value       = aws_eks_cluster.main.platform_version
}

output "cluster_status" {
  description = "Status of the EKS cluster. One of CREATING, ACTIVE, DELETING, FAILED"
  value       = aws_eks_cluster.main.status
}

output "cluster_security_group_id" {
  description = "Cluster security group that was created by Amazon EKS for the cluster"
  value       = aws_eks_cluster.main.vpc_config[0].cluster_security_group_id
}

output "cluster_iam_role_name" {
  description = "IAM role name associated with EKS cluster"
  value       = aws_iam_role.cluster_role.name
}

output "cluster_iam_role_arn" {
  description = "IAM role ARN associated with EKS cluster"
  value       = aws_iam_role.cluster_role.arn
}

output "cluster_certificate_authority_data" {
  description = "Base64 encoded certificate data required to communicate with the cluster"
  value       = aws_eks_cluster.main.certificate_authority[0].data
}

output "cluster_primary_security_group_id" {
  description = "The cluster primary security group ID created by EKS"
  value       = aws_eks_cluster.main.vpc_config[0].cluster_security_group_id
}

# Node Groups Outputs
output "node_groups" {
  description = "EKS node groups"
  value = {
    for idx, ng in aws_eks_node_group.main : ng.node_group_name => {
      arn           = ng.arn
      status        = ng.status
      capacity_type = ng.capacity_type
      instance_types = ng.instance_types
      ami_type      = ng.ami_type
      node_role_arn = ng.node_role_arn
      subnet_ids    = ng.subnet_ids
      scaling_config = ng.scaling_config
      remote_access = ng.remote_access
    }
  }
}

output "node_group_iam_role_name" {
  description = "IAM role name associated with EKS node groups"
  value       = aws_iam_role.node_group_role.name
}

output "node_group_iam_role_arn" {
  description = "IAM role ARN associated with EKS node groups"
  value       = aws_iam_role.node_group_role.arn
}

# Fargate Profiles Outputs
output "fargate_profiles" {
  description = "EKS Fargate profiles"
  value = {
    for idx, fp in aws_eks_fargate_profile.main : fp.fargate_profile_name => {
      arn                    = fp.arn
      status                 = fp.status
      pod_execution_role_arn = fp.pod_execution_role_arn
      subnet_ids             = fp.subnet_ids
      selectors              = fp.selector
    }
  }
}

output "fargate_iam_role_name" {
  description = "IAM role name associated with EKS Fargate profiles"
  value       = length(var.fargate_profiles) > 0 ? aws_iam_role.fargate_role[0].name : null
}

output "fargate_iam_role_arn" {
  description = "IAM role ARN associated with EKS Fargate profiles"
  value       = length(var.fargate_profiles) > 0 ? aws_iam_role.fargate_role[0].arn : null
}

# OIDC Provider Outputs
output "oidc_provider_arn" {
  description = "The ARN of the OIDC Provider if enabled"
  value       = var.enable_irsa ? aws_iam_openid_connect_provider.eks[0].arn : null
}

output "cluster_oidc_issuer_url" {
  description = "The URL on the EKS cluster for the OpenID Connect identity provider"
  value       = local.oidc_issuer_url
}

# KMS Key Outputs
output "kms_key_arn" {
  description = "The Amazon Resource Name (ARN) of the KMS key"
  value       = var.kms_key_arn != "" ? var.kms_key_arn : (var.create_kms_key ? aws_kms_key.eks[0].arn : null)
}

output "kms_key_id" {
  description = "The globally unique identifier for the KMS key"
  value       = var.create_kms_key && var.kms_key_arn == "" ? aws_kms_key.eks[0].key_id : null
}

# CloudWatch Log Group Output
output "cloudwatch_log_group_name" {
  description = "Name of cloudwatch log group created"
  value       = length(var.enabled_cluster_log_types) > 0 ? aws_cloudwatch_log_group.cluster_logs[0].name : null
}

output "cloudwatch_log_group_arn" {
  description = "Arn of cloudwatch log group created"
  value       = length(var.enabled_cluster_log_types) > 0 ? aws_cloudwatch_log_group.cluster_logs[0].arn : null
}

# Additional Security Group Outputs
output "additional_security_group_id" {
  description = "ID of the additional security group created for the cluster"
  value       = var.create_additional_security_group ? aws_security_group.cluster_additional[0].id : null
}

output "additional_security_group_arn" {
  description = "ARN of the additional security group created for the cluster"
  value       = var.create_additional_security_group ? aws_security_group.cluster_additional[0].arn : null
}

# EKS Add-ons Outputs
output "cluster_addons" {
  description = "Map of attribute maps for all EKS cluster addons enabled"
  value = {
    for addon in aws_eks_addon.main : addon.addon_name => {
      arn               = addon.arn
      status            = addon.status
      addon_version     = addon.addon_version
      resolve_conflicts = addon.resolve_conflicts
    }
  }
}