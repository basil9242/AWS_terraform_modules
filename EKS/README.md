# EKS (Elastic Kubernetes Service) Module

This Terraform module creates a comprehensive Amazon EKS cluster with node groups, Fargate profiles, and all necessary supporting resources for a production-ready Kubernetes environment.

## Overview

The EKS module provides a complete Kubernetes cluster solution with:
- **High Availability**: Multi-AZ deployment with configurable node groups
- **Security**: KMS encryption, IAM roles, and security groups
- **Scalability**: Auto-scaling node groups and Fargate profiles
- **Monitoring**: CloudWatch logging and metrics integration
- **Flexibility**: Support for both EC2 and Fargate compute options

## Features

### Core Features
- **EKS Cluster**: Fully managed Kubernetes control plane
- **Node Groups**: Managed EC2 instances for workloads
- **Fargate Profiles**: Serverless compute for pods
- **KMS Encryption**: Encryption at rest for secrets
- **CloudWatch Logging**: Comprehensive cluster logging
- **IRSA Support**: IAM Roles for Service Accounts

### Advanced Features
- **Multiple Node Groups**: Support for different instance types and configurations
- **Mixed Capacity Types**: ON_DEMAND and SPOT instances
- **Custom AMI Types**: Support for various AMI types including ARM64
- **Add-ons Management**: Automatic installation of essential add-ons
- **Security Groups**: Additional security group configuration
- **OIDC Provider**: OpenID Connect for service account authentication

## Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                           EKS Cluster                          │
│  ┌─────────────────┐    ┌─────────────────┐                   │
│  │   Control Plane │    │   Data Plane    │                   │
│  │                 │    │                 │                   │
│  │ - API Server    │    │ - Node Groups   │                   │
│  │ - etcd          │    │ - Fargate       │                   │
│  │ - Scheduler     │    │ - Add-ons       │                   │
│  │ - Controller    │    │                 │                   │
│  └─────────────────┘    └─────────────────┘                   │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                    Supporting Resources                         │
│                                                                 │
│ ┌─────────────┐ ┌─────────────┐ ┌─────────────┐ ┌─────────────┐│
│ │ IAM Roles   │ │ KMS Keys    │ │ CloudWatch  │ │ Security    ││
│ │             │ │             │ │ Logs        │ │ Groups      ││
│ │ - Cluster   │ │ - Encryption│ │             │ │             ││
│ │ - NodeGroup │ │ - Secrets   │ │ - API Logs  │ │ - Network   ││
│ │ - Fargate   │ │             │ │ - Audit     │ │ - Access    ││
│ └─────────────┘ └─────────────┘ └─────────────┘ └─────────────┘│
└─────────────────────────────────────────────────────────────────┘
```

## Usage

### Basic Usage

```hcl
module "eks" {
  source = "./EKS"

  cluster_name       = "my-eks-cluster"
  kubernetes_version = "1.28"
  vpc_id            = module.vpc.vpc_id
  subnet_ids        = module.vpc.private_subnet_ids

  node_groups = [{
    name           = "general"
    subnet_ids     = module.vpc.private_subnet_ids
    capacity_type  = "ON_DEMAND"
    instance_types = ["t3.medium"]
    ami_type       = "AL2_x86_64"
    disk_size      = 20
    desired_size   = 2
    max_size       = 4
    min_size       = 1
    max_unavailable_percentage = 25
  }]

  tags = {
    Environment = "dev"
    Project     = "my-project"
  }
}
```

### Production Setup with Multiple Node Groups

```hcl
module "eks" {
  source = "./EKS"

  cluster_name       = "production-eks"
  kubernetes_version = "1.28"
  vpc_id            = module.vpc.vpc_id
  subnet_ids        = module.vpc.private_subnet_ids

  # Cluster Configuration
  endpoint_private_access = true
  endpoint_public_access  = false
  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  log_retention_days = 30

  # Multiple Node Groups
  node_groups = [
    {
      name           = "system"
      subnet_ids     = module.vpc.private_subnet_ids
      capacity_type  = "ON_DEMAND"
      instance_types = ["t3.medium"]
      ami_type       = "AL2_x86_64"
      disk_size      = 20
      desired_size   = 2
      max_size       = 4
      min_size       = 2
      max_unavailable_percentage = 25
    },
    {
      name           = "applications"
      subnet_ids     = module.vpc.private_subnet_ids
      capacity_type  = "SPOT"
      instance_types = ["t3.large", "t3.xlarge"]
      ami_type       = "AL2_x86_64"
      disk_size      = 50
      desired_size   = 3
      max_size       = 10
      min_size       = 1
      max_unavailable_percentage = 50
    }
  ]

  # Fargate Profile for serverless workloads
  fargate_profiles = [{
    name       = "serverless"
    subnet_ids = module.vpc.private_subnet_ids
    selectors = [{
      namespace = "fargate"
      labels    = {}
    }]
  }]

  # Enable IRSA
  enable_irsa = true

  # Additional Security Group
  create_additional_security_group = true
  additional_security_group_rules = {
    ingress = [{
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/8"]
      description = "HTTPS from VPC"
    }]
    egress = [{
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      description = "All outbound traffic"
    }]
  }

  tags = {
    Environment = "production"
    Project     = "my-project"
    Owner       = "platform-team"
  }
}
```

### Fargate-Only Setup

```hcl
module "eks" {
  source = "./EKS"

  cluster_name       = "fargate-eks"
  kubernetes_version = "1.28"
  vpc_id            = module.vpc.vpc_id
  subnet_ids        = module.vpc.private_subnet_ids

  # No node groups - Fargate only
  node_groups = []

  # Fargate Profiles
  fargate_profiles = [
    {
      name       = "default"
      subnet_ids = module.vpc.private_subnet_ids
      selectors = [{
        namespace = "default"
        labels    = {}
      }]
    },
    {
      name       = "kube-system"
      subnet_ids = module.vpc.private_subnet_ids
      selectors = [{
        namespace = "kube-system"
        labels    = {}
      }]
    }
  ]

  # Custom add-ons for Fargate
  cluster_addons = [
    {
      name                     = "vpc-cni"
      version                  = null
      resolve_conflicts        = "OVERWRITE"
      service_account_role_arn = null
    },
    {
      name                     = "coredns"
      version                  = null
      resolve_conflicts        = "OVERWRITE"
      service_account_role_arn = null
    }
  ]

  tags = {
    Environment = "serverless"
    Project     = "my-project"
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| aws | >= 5.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 5.0 |

## Resources Created

| Resource | Type | Description |
|----------|------|-------------|
| `aws_eks_cluster.main` | EKS Cluster | Main EKS cluster |
| `aws_eks_node_group.main` | EKS Node Group | Managed node groups |
| `aws_eks_fargate_profile.main` | EKS Fargate Profile | Fargate profiles |
| `aws_eks_addon.main` | EKS Add-on | Cluster add-ons |
| `aws_iam_role.cluster_role` | IAM Role | EKS cluster service role |
| `aws_iam_role.node_group_role` | IAM Role | EKS node group role |
| `aws_iam_role.fargate_role` | IAM Role | EKS Fargate execution role |
| `aws_kms_key.eks` | KMS Key | Encryption key for EKS |
| `aws_cloudwatch_log_group.cluster_logs` | CloudWatch Log Group | Cluster logging |
| `aws_security_group.cluster_additional` | Security Group | Additional cluster security group |
| `aws_iam_openid_connect_provider.eks` | OIDC Provider | For IRSA support |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `cluster_name` | Name of the EKS cluster | `string` | n/a | yes |
| `kubernetes_version` | Kubernetes version to use for the EKS cluster | `string` | `"1.28"` | no |
| `vpc_id` | VPC ID where the cluster will be deployed | `string` | n/a | yes |
| `subnet_ids` | List of subnet IDs for the EKS cluster | `list(string)` | n/a | yes |
| `endpoint_private_access` | Whether the Amazon EKS private API server endpoint is enabled | `bool` | `true` | no |
| `endpoint_public_access` | Whether the Amazon EKS public API server endpoint is enabled | `bool` | `false` | no |
| `public_access_cidrs` | List of CIDR blocks that can access the Amazon EKS public API server endpoint | `list(string)` | `["0.0.0.0/0"]` | no |
| `enabled_cluster_log_types` | List of control plane logging to enable | `list(string)` | `["api", "audit", "authenticator", "controllerManager", "scheduler"]` | no |
| `log_retention_days` | Number of days to retain log events | `number` | `7` | no |
| `node_groups` | List of EKS node group configurations | `list(object)` | `[]` | no |
| `fargate_profiles` | List of EKS Fargate profile configurations | `list(object)` | `[]` | no |
| `cluster_addons` | List of EKS cluster add-ons | `list(object)` | See variables.tf | no |
| `enable_irsa` | Whether to create an OpenID Connect Provider for EKS to enable IRSA | `bool` | `true` | no |
| `create_kms_key` | Whether to create a KMS key for EKS encryption | `bool` | `true` | no |
| `kms_key_arn` | ARN of the KMS key to use for encryption | `string` | `""` | no |
| `create_additional_security_group` | Whether to create an additional security group for the EKS cluster | `bool` | `false` | no |
| `tags` | A map of tags to assign to the resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| `cluster_id` | The ID of the EKS cluster |
| `cluster_arn` | The Amazon Resource Name (ARN) of the cluster |
| `cluster_name` | The name of the EKS cluster |
| `cluster_endpoint` | Endpoint for your Kubernetes API server |
| `cluster_version` | The Kubernetes version for the cluster |
| `cluster_security_group_id` | Cluster security group that was created by Amazon EKS |
| `cluster_iam_role_arn` | IAM role ARN associated with EKS cluster |
| `cluster_certificate_authority_data` | Base64 encoded certificate data required to communicate with the cluster |
| `node_groups` | EKS node groups information |
| `fargate_profiles` | EKS Fargate profiles information |
| `oidc_provider_arn` | The ARN of the OIDC Provider if enabled |
| `cluster_oidc_issuer_url` | The URL on the EKS cluster for the OpenID Connect identity provider |
| `kms_key_arn` | The Amazon Resource Name (ARN) of the KMS key |
| `cloudwatch_log_group_name` | Name of cloudwatch log group created |

## Node Group Configuration

Node groups support the following configuration options:

### Instance Types
- **General Purpose**: t3.micro, t3.small, t3.medium, t3.large, t3.xlarge, t3.2xlarge
- **Compute Optimized**: c5.large, c5.xlarge, c5.2xlarge, c5.4xlarge
- **Memory Optimized**: r5.large, r5.xlarge, r5.2xlarge, r5.4xlarge
- **ARM-based**: t4g.micro, t4g.small, t4g.medium, t4g.large

### AMI Types
- `AL2_x86_64`: Amazon Linux 2 (x86_64)
- `AL2_x86_64_GPU`: Amazon Linux 2 with GPU support
- `AL2_ARM_64`: Amazon Linux 2 (ARM64)
- `BOTTLEROCKET_ARM_64`: Bottlerocket (ARM64)
- `BOTTLEROCKET_x86_64`: Bottlerocket (x86_64)

### Capacity Types
- `ON_DEMAND`: On-Demand instances
- `SPOT`: Spot instances (cost-effective but can be interrupted)

## Fargate Configuration

Fargate profiles allow you to run pods without managing EC2 instances:

```hcl
fargate_profiles = [{
  name       = "my-fargate-profile"
  subnet_ids = var.private_subnet_ids
  selectors = [{
    namespace = "my-namespace"
    labels = {
      "app" = "my-app"
    }
  }]
}]
```

## Add-ons

The module supports the following EKS add-ons:

### Essential Add-ons (Default)
- **vpc-cni**: Amazon VPC CNI plugin for Kubernetes
- **coredns**: CoreDNS for DNS resolution
- **kube-proxy**: Kubernetes network proxy

### Optional Add-ons
- **aws-ebs-csi-driver**: Amazon EBS CSI driver
- **aws-efs-csi-driver**: Amazon EFS CSI driver
- **adot**: AWS Distro for OpenTelemetry

## Security Best Practices

### 1. Network Security
- Use private subnets for node groups
- Restrict public API access with specific CIDR blocks
- Configure security groups with minimal required access

### 2. IAM Security
- Enable IRSA for service account authentication
- Use least privilege IAM policies
- Regularly rotate access keys

### 3. Encryption
- Enable KMS encryption for secrets
- Use encrypted EBS volumes for node groups
- Enable CloudWatch Logs encryption

### 4. Monitoring
- Enable all cluster log types for comprehensive monitoring
- Set appropriate log retention periods
- Monitor cluster metrics with CloudWatch

## Cost Optimization

### 1. Node Group Optimization
- Use Spot instances for non-critical workloads
- Right-size instance types based on workload requirements
- Enable cluster autoscaler for dynamic scaling

### 2. Fargate vs EC2
- Use Fargate for:
  - Batch jobs and scheduled tasks
  - Applications with unpredictable traffic
  - Development and testing environments
- Use EC2 node groups for:
  - Long-running applications
  - High-performance computing workloads
  - Cost-sensitive production workloads

### 3. Resource Management
- Set appropriate resource requests and limits
- Use horizontal pod autoscaler (HPA)
- Implement vertical pod autoscaler (VPA) for right-sizing

## Troubleshooting

### Common Issues

1. **Node Group Creation Fails**
   ```bash
   # Check IAM permissions
   aws iam get-role --role-name <node-group-role-name>
   
   # Verify subnet configuration
   aws ec2 describe-subnets --subnet-ids <subnet-id>
   ```

2. **Pods Cannot Pull Images**
   ```bash
   # Check ECR permissions
   aws ecr get-login-token --region <region>
   
   # Verify node group IAM role has ECR permissions
   aws iam list-attached-role-policies --role-name <node-group-role>
   ```

3. **IRSA Not Working**
   ```bash
   # Verify OIDC provider exists
   aws iam list-open-id-connect-providers
   
   # Check service account annotations
   kubectl describe serviceaccount <service-account-name>
   ```

### Debugging Commands

```bash
# Check cluster status
aws eks describe-cluster --name <cluster-name>

# List node groups
aws eks list-nodegroups --cluster-name <cluster-name>

# Check add-on status
aws eks list-addons --cluster-name <cluster-name>

# View cluster logs
aws logs describe-log-groups --log-group-name-prefix "/aws/eks"

# Check kubectl connectivity
kubectl cluster-info
kubectl get nodes
kubectl get pods --all-namespaces
```

## Integration Examples

### With Application Load Balancer

```hcl
# Deploy AWS Load Balancer Controller
resource "kubernetes_service_account" "aws_load_balancer_controller" {
  metadata {
    name      = "aws-load-balancer-controller"
    namespace = "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.aws_load_balancer_controller.arn
    }
  }
}

# IAM role for AWS Load Balancer Controller
resource "aws_iam_role" "aws_load_balancer_controller" {
  name = "${var.cluster_name}-aws-load-balancer-controller"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Principal = {
          Federated = module.eks.oidc_provider_arn
        }
        Condition = {
          StringEquals = {
            "${replace(module.eks.cluster_oidc_issuer_url, "https://", "")}:sub": "system:serviceaccount:kube-system:aws-load-balancer-controller"
            "${replace(module.eks.cluster_oidc_issuer_url, "https://", "")}:aud": "sts.amazonaws.com"
          }
        }
      }
    ]
  })
}
```

### With Cluster Autoscaler

```hcl
# IAM role for Cluster Autoscaler
resource "aws_iam_role" "cluster_autoscaler" {
  name = "${var.cluster_name}-cluster-autoscaler"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Principal = {
          Federated = module.eks.oidc_provider_arn
        }
        Condition = {
          StringEquals = {
            "${replace(module.eks.cluster_oidc_issuer_url, "https://", "")}:sub": "system:serviceaccount:kube-system:cluster-autoscaler"
            "${replace(module.eks.cluster_oidc_issuer_url, "https://", "")}:aud": "sts.amazonaws.com"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "cluster_autoscaler" {
  name = "cluster-autoscaler"
  role = aws_iam_role.cluster_autoscaler.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "autoscaling:DescribeAutoScalingGroups",
          "autoscaling:DescribeAutoScalingInstances",
          "autoscaling:DescribeLaunchConfigurations",
          "autoscaling:DescribeTags",
          "autoscaling:SetDesiredCapacity",
          "autoscaling:TerminateInstanceInAutoScalingGroup",
          "ec2:DescribeLaunchTemplateVersions"
        ]
        Resource = "*"
      }
    ]
  })
}
```

## Contributing

1. Follow Terraform best practices
2. Add appropriate variable validation
3. Include comprehensive documentation
4. Test with different EKS configurations
5. Ensure IAM permissions follow least privilege principle

## License

This module is licensed under the MIT License.