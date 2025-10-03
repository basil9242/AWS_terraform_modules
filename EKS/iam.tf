# EKS Cluster IAM Role
resource "aws_iam_role" "cluster_role" {
  name = "${var.cluster_name}-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      }
    ]
  })

  tags = merge(var.tags, {
    Name = "${var.cluster_name}-cluster-role"
  })
}

# EKS Cluster IAM Role Policy Attachments
resource "aws_iam_role_policy_attachment" "cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster_role.name
}

resource "aws_iam_role_policy_attachment" "cluster_service_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.cluster_role.name
}

# EKS Node Group IAM Role
resource "aws_iam_role" "node_group_role" {
  name = "${var.cluster_name}-node-group-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = merge(var.tags, {
    Name = "${var.cluster_name}-node-group-role"
  })
}

# EKS Node Group IAM Role Policy Attachments
resource "aws_iam_role_policy_attachment" "node_group_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.node_group_role.name
}

resource "aws_iam_role_policy_attachment" "node_group_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.node_group_role.name
}

resource "aws_iam_role_policy_attachment" "node_group_registry_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.node_group_role.name
}

# EKS Fargate IAM Role
resource "aws_iam_role" "fargate_role" {
  count = length(var.fargate_profiles) > 0 ? 1 : 0
  name  = "${var.cluster_name}-fargate-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks-fargate-pods.amazonaws.com"
        }
      }
    ]
  })

  tags = merge(var.tags, {
    Name = "${var.cluster_name}-fargate-role"
  })
}

# EKS Fargate IAM Role Policy Attachment
resource "aws_iam_role_policy_attachment" "fargate_policy" {
  count      = length(var.fargate_profiles) > 0 ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
  role       = aws_iam_role.fargate_role[0].name
}

# Additional IAM policy for EKS cluster (CloudWatch Logs)
resource "aws_iam_role_policy" "cluster_logs_policy" {
  name = "${var.cluster_name}-cluster-logs-policy"
  role = aws_iam_role.cluster_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams"
        ]
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}

# IAM policy for EKS cluster to use KMS
resource "aws_iam_role_policy" "cluster_kms_policy" {
  name = "${var.cluster_name}-cluster-kms-policy"
  role = aws_iam_role.cluster_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ]
        Resource = var.kms_key_arn != "" ? var.kms_key_arn : aws_kms_key.eks[0].arn
      }
    ]
  })
}

# Data source for current AWS caller identity
data "aws_caller_identity" "current" {}

# Data source for current AWS region
data "aws_region" "current" {}

# Data source for EKS cluster OIDC issuer URL
data "aws_eks_cluster" "cluster" {
  name = aws_eks_cluster.main.name
}

# Extract OIDC issuer URL
locals {
  oidc_issuer_url = data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer
}

# OIDC Identity Provider for IRSA (IAM Roles for Service Accounts)
resource "aws_iam_openid_connect_provider" "eks" {
  count = var.enable_irsa ? 1 : 0

  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["9e99a48a9960b14926bb7f3b02e22da2b0ab7280"]
  url             = local.oidc_issuer_url

  tags = merge(var.tags, {
    Name = "${var.cluster_name}-oidc-provider"
  })
}