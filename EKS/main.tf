# EKS Cluster
resource "aws_eks_cluster" "main" {
  name     = var.cluster_name
  role_arn = aws_iam_role.cluster_role.arn
  version  = var.kubernetes_version

  vpc_config {
    subnet_ids              = var.subnet_ids
    endpoint_private_access = var.endpoint_private_access
    endpoint_public_access  = var.endpoint_public_access
    public_access_cidrs     = var.public_access_cidrs
    security_group_ids      = var.additional_security_group_ids
  }

  encryption_config {
    provider {
      key_arn = var.kms_key_arn != "" ? var.kms_key_arn : aws_kms_key.eks[0].arn
    }
    resources = ["secrets"]
  }

  enabled_cluster_log_types = var.enabled_cluster_log_types

  depends_on = [
    aws_iam_role_policy_attachment.cluster_policy,
    aws_iam_role_policy_attachment.cluster_service_policy,
    aws_cloudwatch_log_group.cluster_logs
  ]

  tags = merge(var.tags, {
    Name = var.cluster_name
  })
}

# EKS Node Group
resource "aws_eks_node_group" "main" {
  count = length(var.node_groups)

  cluster_name    = aws_eks_cluster.main.name
  node_group_name = var.node_groups[count.index].name
  node_role_arn   = aws_iam_role.node_group_role.arn
  subnet_ids      = var.node_groups[count.index].subnet_ids

  capacity_type  = var.node_groups[count.index].capacity_type
  instance_types = var.node_groups[count.index].instance_types
  ami_type       = var.node_groups[count.index].ami_type
  disk_size      = var.node_groups[count.index].disk_size

  scaling_config {
    desired_size = var.node_groups[count.index].desired_size
    max_size     = var.node_groups[count.index].max_size
    min_size     = var.node_groups[count.index].min_size
  }

  update_config {
    max_unavailable_percentage = var.node_groups[count.index].max_unavailable_percentage
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  depends_on = [
    aws_iam_role_policy_attachment.node_group_policy,
    aws_iam_role_policy_attachment.node_group_cni_policy,
    aws_iam_role_policy_attachment.node_group_registry_policy,
  ]

  # Optional: Allow external changes without Terraform plan difference
  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }

  tags = merge(var.tags, {
    Name = var.node_groups[count.index].name
  })
}

# EKS Fargate Profile
resource "aws_eks_fargate_profile" "main" {
  count = length(var.fargate_profiles)

  cluster_name           = aws_eks_cluster.main.name
  fargate_profile_name   = var.fargate_profiles[count.index].name
  pod_execution_role_arn = aws_iam_role.fargate_role[0].arn
  subnet_ids             = var.fargate_profiles[count.index].subnet_ids

  dynamic "selector" {
    for_each = var.fargate_profiles[count.index].selectors
    content {
      namespace = selector.value.namespace
      labels    = selector.value.labels
    }
  }

  depends_on = [
    aws_iam_role_policy_attachment.fargate_policy,
  ]

  tags = merge(var.tags, {
    Name = var.fargate_profiles[count.index].name
  })
}

# EKS Add-ons
resource "aws_eks_addon" "main" {
  count = length(var.cluster_addons)

  cluster_name             = aws_eks_cluster.main.name
  addon_name               = var.cluster_addons[count.index].name
  addon_version            = var.cluster_addons[count.index].version
  resolve_conflicts        = var.cluster_addons[count.index].resolve_conflicts
  service_account_role_arn = var.cluster_addons[count.index].service_account_role_arn

  depends_on = [
    aws_eks_node_group.main,
    aws_eks_fargate_profile.main
  ]

  tags = var.tags
}

# CloudWatch Log Group for EKS Cluster
resource "aws_cloudwatch_log_group" "cluster_logs" {
  count = length(var.enabled_cluster_log_types) > 0 ? 1 : 0

  name              = "/aws/eks/${var.cluster_name}/cluster"
  retention_in_days = var.log_retention_days
  kms_key_id        = var.kms_key_arn != "" ? var.kms_key_arn : aws_kms_key.eks[0].arn

  tags = var.tags
}

# Security Group for additional EKS cluster security
resource "aws_security_group" "cluster_additional" {
  count = var.create_additional_security_group ? 1 : 0

  name_prefix = "${var.cluster_name}-additional-"
  vpc_id      = var.vpc_id
  description = "Additional security group for EKS cluster ${var.cluster_name}"

  tags = merge(var.tags, {
    Name = "${var.cluster_name}-additional-sg"
  })
}

# Security Group Rules for additional security group
resource "aws_security_group_rule" "cluster_additional_ingress" {
  count = var.create_additional_security_group ? length(var.additional_security_group_rules.ingress) : 0

  type              = "ingress"
  from_port         = var.additional_security_group_rules.ingress[count.index].from_port
  to_port           = var.additional_security_group_rules.ingress[count.index].to_port
  protocol          = var.additional_security_group_rules.ingress[count.index].protocol
  cidr_blocks       = var.additional_security_group_rules.ingress[count.index].cidr_blocks
  security_group_id = aws_security_group.cluster_additional[0].id
  description       = var.additional_security_group_rules.ingress[count.index].description
}

resource "aws_security_group_rule" "cluster_additional_egress" {
  count = var.create_additional_security_group ? length(var.additional_security_group_rules.egress) : 0

  type              = "egress"
  from_port         = var.additional_security_group_rules.egress[count.index].from_port
  to_port           = var.additional_security_group_rules.egress[count.index].to_port
  protocol          = var.additional_security_group_rules.egress[count.index].protocol
  cidr_blocks       = var.additional_security_group_rules.egress[count.index].cidr_blocks
  security_group_id = aws_security_group.cluster_additional[0].id
  description       = var.additional_security_group_rules.egress[count.index].description
}