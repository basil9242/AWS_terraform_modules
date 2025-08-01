# AWS ECR Terraform Module

A comprehensive Terraform module for creating and managing AWS Elastic Container Registry (ECR) repositories with advanced security features, lifecycle policies, and KMS encryption.

## Features

- ✅ **ECR Repositories** with configurable image tag mutability
- ✅ **KMS Encryption** for images at rest
- ✅ **Repository Policies** with JSON file support
- ✅ **Lifecycle Policies** for image management
- ✅ **Image Scanning** for vulnerability detection
- ✅ **Cross-Account Access** support
- ✅ **Comprehensive Tagging** support
- ✅ **Variable Validation** for input safety

## Usage

### Basic ECR Repository

```hcl
module "ecr_repository" {
  source = "git::https://github.com/basil9242/AWS_terraform_modules.git//ECR"
  
  ecr_name = "my-application"
  
  tags = {
    Environment = "production"
    Application = "my-app"
  }
}
```

### Advanced ECR Repository with All Features

```hcl
module "ecr_repository" {
  source = "git::https://github.com/basil9242/AWS_terraform_modules.git//ECR"
  
  # Repository Configuration
  ecr_name                 = "my-advanced-app"
  ecr_image_tag_mutability = "IMMUTABLE"
  
  # Security Configuration
  enable_image_scanning = true
  scan_on_push         = true
  
  # Lifecycle Policy
  enable_lifecycle_policy = true
  lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last 10 production images"
        selection = {
          tagStatus     = "tagged"
          tagPrefixList = ["prod"]
          countType     = "imageCountMoreThan"
          countNumber   = 10
        }
        action = {
          type = "expire"
        }
      },
      {
        rulePriority = 2
        description  = "Keep last 5 development images"
        selection = {
          tagStatus     = "tagged"
          tagPrefixList = ["dev"]
          countType     = "imageCountMoreThan"
          countNumber   = 5
        }
        action = {
          type = "expire"
        }
      },
      {
        rulePriority = 3
        description  = "Delete untagged images older than 1 day"
        selection = {
          tagStatus   = "untagged"
          countType   = "sinceImagePushed"
          countUnit   = "days"
          countNumber = 1
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
  
  # Repository Policy
  ecr_repository_policy_required = true
  ecr_policy_json_file_path     = "./policies/ecr-policy.json"
  
  # KMS Configuration
  enable_kms_encryption   = true
  kms_key_deletion_window = 30
  enable_kms_key_rotation = true
  
  # Tagging
  environment = "production"
  tags = {
    Owner       = "platform-team"
    CostCenter  = "engineering"
    Compliance  = "required"
    Application = "my-advanced-app"
  }
}
```

### Multiple ECR Repositories

```hcl
locals {
  repositories = {
    frontend = {
      name        = "my-app-frontend"
      mutability  = "MUTABLE"
      environment = "development"
    }
    backend = {
      name        = "my-app-backend"
      mutability  = "IMMUTABLE"
      environment = "production"
    }
    worker = {
      name        = "my-app-worker"
      mutability  = "IMMUTABLE"
      environment = "production"
    }
  }
}

module "ecr_repositories" {
  source = "git::https://github.com/basil9242/AWS_terraform_modules.git//ECR"
  
  for_each = local.repositories
  
  ecr_name                 = each.value.name
  ecr_image_tag_mutability = each.value.mutability
  
  # Enable scanning for production repositories
  enable_image_scanning = each.value.environment == "production"
  scan_on_push         = each.value.environment == "production"
  
  # Lifecycle policy for all repositories
  enable_lifecycle_policy = true
  lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last 10 images"
        selection = {
          tagStatus   = "any"
          countType   = "imageCountMoreThan"
          countNumber = 10
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
  
  environment = each.value.environment
  tags = {
    Component = each.key
    Service   = "my-app"
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| aws | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| aws | ~> 5.0 |

## Resources Created

| Resource | Description |
|----------|-------------|
| `aws_ecr_repository` | ECR repository for container images |
| `aws_ecr_repository_policy` | Repository access policy (optional) |
| `aws_ecr_lifecycle_policy` | Lifecycle policy for image management (optional) |
| `aws_kms_key` | KMS key for image encryption |
| `aws_kms_key_policy` | KMS key policy |
| `aws_kms_alias` | KMS key alias |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `ecr_name` | Name of the ECR repository | `string` | n/a | yes |
| `ecr_image_tag_mutability` | Image tag mutability (MUTABLE or IMMUTABLE) | `string` | `"IMMUTABLE"` | no |
| `enable_image_scanning` | Enable image vulnerability scanning | `bool` | `true` | no |
| `scan_on_push` | Scan images on push | `bool` | `true` | no |
| `enable_lifecycle_policy` | Enable lifecycle policy | `bool` | `false` | no |
| `lifecycle_policy` | Lifecycle policy JSON | `string` | `null` | no |
| `ecr_repository_policy_required` | Enable repository policy | `bool` | `false` | no |
| `ecr_policy_json_file_path` | Path to repository policy JSON file | `string` | `null` | no |
| `enable_kms_encryption` | Enable KMS encryption | `bool` | `true` | no |
| `kms_key_deletion_window` | KMS key deletion window (7-30 days) | `number` | `20` | no |
| `enable_kms_key_rotation` | Enable automatic KMS key rotation | `bool` | `true` | no |
| `tags` | Resource tags | `map(string)` | `{}` | no |
| `environment` | Environment name | `string` | `"dev"` | no |

## Outputs

| Name | Description |
|------|-------------|
| `ecr_repository_arn` | ECR repository ARN |
| `ecr_repository_url` | ECR repository URL |
| `ecr_repository_name` | ECR repository name |
| `ecr_registry_id` | ECR registry ID |
| `kms_key_id` | KMS key ID |
| `kms_key_arn` | KMS key ARN |
| `kms_alias_name` | KMS key alias name |

## Examples

### Microservices ECR Setup

```hcl
locals {
  microservices = [
    "user-service",
    "order-service", 
    "payment-service",
    "notification-service",
    "api-gateway"
  ]
}

module "microservices_ecr" {
  source = "git::https://github.com/basil9242/AWS_terraform_modules.git//ECR"
  
  for_each = toset(local.microservices)
  
  ecr_name                 = "mycompany-${each.value}"
  ecr_image_tag_mutability = "IMMUTABLE"
  
  # Enable security scanning
  enable_image_scanning = true
  scan_on_push         = true
  
  # Lifecycle policy to manage image retention
  enable_lifecycle_policy = true
  lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last 20 production images"
        selection = {
          tagStatus     = "tagged"
          tagPrefixList = ["v", "release"]
          countType     = "imageCountMoreThan"
          countNumber   = 20
        }
        action = {
          type = "expire"
        }
      },
      {
        rulePriority = 2
        description  = "Keep last 5 development images"
        selection = {
          tagStatus     = "tagged"
          tagPrefixList = ["dev", "feature"]
          countType     = "imageCountMoreThan"
          countNumber   = 5
        }
        action = {
          type = "expire"
        }
      },
      {
        rulePriority = 3
        description  = "Delete untagged images after 1 day"
        selection = {
          tagStatus   = "untagged"
          countType   = "sinceImagePushed"
          countUnit   = "days"
          countNumber = 1
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
  
  tags = {
    Service     = each.value
    Environment = "production"
    Team        = "platform"
  }
}
```

### Cross-Account ECR Repository

```hcl
# ECR repository policy for cross-account access
data "aws_iam_policy_document" "ecr_cross_account_policy" {
  statement {
    sid    = "CrossAccountAccess"
    effect = "Allow"
    
    principals {
      type        = "AWS"
      identifiers = [
        "arn:aws:iam::123456789012:root",  # Development account
        "arn:aws:iam::123456789013:root"   # Staging account
      ]
    }
    
    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetRepositoryPolicy",
      "ecr:DescribeRepositories",
      "ecr:ListImages",
      "ecr:DescribeImages",
      "ecr:BatchDeleteImage",
      "ecr:GetLifecyclePolicy",
      "ecr:GetLifecyclePolicyPreview",
      "ecr:ListTagsForResource",
      "ecr:DescribeImageScanFindings"
    ]
  }
  
  statement {
    sid    = "LambdaAccess"
    effect = "Allow"
    
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    
    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage"
    ]
  }
}

module "shared_ecr" {
  source = "git::https://github.com/basil9242/AWS_terraform_modules.git//ECR"
  
  ecr_name                 = "shared-base-images"
  ecr_image_tag_mutability = "IMMUTABLE"
  
  # Cross-account policy
  ecr_repository_policy_required = true
  ecr_repository_policy         = data.aws_iam_policy_document.ecr_cross_account_policy.json
  
  # Long retention for base images
  enable_lifecycle_policy = true
  lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last 50 tagged images"
        selection = {
          tagStatus   = "tagged"
          countType   = "imageCountMoreThan"
          countNumber = 50
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
  
  tags = {
    Purpose = "shared-base-images"
    Access  = "cross-account"
  }
}
```

### CI/CD Pipeline ECR

```hcl
module "cicd_ecr" {
  source = "git::https://github.com/basil9242/AWS_terraform_modules.git//ECR"
  
  ecr_name                 = "myapp-cicd"
  ecr_image_tag_mutability = "MUTABLE"  # Allow overwriting for CI/CD
  
  # Enable scanning for security
  enable_image_scanning = true
  scan_on_push         = true
  
  # Aggressive cleanup for CI/CD images
  enable_lifecycle_policy = true
  lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep only latest 3 images per branch"
        selection = {
          tagStatus   = "tagged"
          countType   = "imageCountMoreThan"
          countNumber = 3
        }
        action = {
          type = "expire"
        }
      },
      {
        rulePriority = 2
        description  = "Delete untagged images immediately"
        selection = {
          tagStatus   = "untagged"
          countType   = "sinceImagePushed"
          countUnit   = "hours"
          countNumber = 1
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
  
  tags = {
    Purpose = "ci-cd"
    Team    = "devops"
  }
}
```

## Repository Policy Examples

### Basic Cross-Account Access Policy

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "CrossAccountAccess",
      "Effect": "Allow",
      "Principal": {
        "AWS": [
          "arn:aws:iam::123456789012:root",
          "arn:aws:iam::123456789013:root"
        ]
      },
      "Action": [
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "ecr:BatchCheckLayerAvailability"
      ]
    }
  ]
}
```

### Service-Specific Access Policy

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "ECSTaskAccess",
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": [
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage"
      ]
    },
    {
      "Sid": "LambdaAccess",
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": [
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage"
      ]
    }
  ]
}
```

## Lifecycle Policy Examples

### Production Image Retention

```json
{
  "rules": [
    {
      "rulePriority": 1,
      "description": "Keep last 30 production images",
      "selection": {
        "tagStatus": "tagged",
        "tagPrefixList": ["prod", "v"],
        "countType": "imageCountMoreThan",
        "countNumber": 30
      },
      "action": {
        "type": "expire"
      }
    },
    {
      "rulePriority": 2,
      "description": "Keep last 10 development images",
      "selection": {
        "tagStatus": "tagged",
        "tagPrefixList": ["dev", "feature"],
        "countType": "imageCountMoreThan",
        "countNumber": 10
      },
      "action": {
        "type": "expire"
      }
    },
    {
      "rulePriority": 3,
      "description": "Delete untagged images older than 1 day",
      "selection": {
        "tagStatus": "untagged",
        "countType": "sinceImagePushed",
        "countUnit": "days",
        "countNumber": 1
      },
      "action": {
        "type": "expire"
      }
    }
  ]
}
```

## Best Practices

1. **Use IMMUTABLE tags** - For production repositories to prevent accidental overwrites
2. **Enable image scanning** - Detect vulnerabilities in container images
3. **Implement lifecycle policies** - Manage storage costs and cleanup old images
4. **Use least privilege policies** - Grant minimal required permissions
5. **Enable KMS encryption** - Protect images at rest
6. **Consistent tagging** - Use semantic versioning and environment tags
7. **Monitor repository metrics** - Track image pushes, pulls, and storage usage
8. **Regular security reviews** - Audit repository policies and access patterns

## Security Considerations

- Images are encrypted at rest with KMS by default
- Repository policies should follow least privilege principle
- Image scanning helps identify vulnerabilities
- Cross-account access should be carefully controlled
- Use IAM roles instead of access keys for authentication
- Regular rotation of KMS keys is enabled by default

## Cost Optimization

- Implement aggressive lifecycle policies for development repositories
- Use lifecycle policies to transition old images to cheaper storage
- Monitor repository storage usage with CloudWatch metrics
- Delete unused repositories regularly
- Consider image deduplication for similar base images

## Monitoring and Alerting

- Set up CloudWatch alarms for repository metrics
- Monitor image scan results for vulnerabilities
- Track repository storage costs
- Alert on failed image pushes or pulls
- Monitor cross-account access patterns

## Integration with CI/CD

### GitHub Actions Example

```yaml
name: Build and Push to ECR

on:
  push:
    branches: [main, develop]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Configure AWS credentials
        uses: aws-actions/configure-aws-credentials@v2
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: us-east-1
      
      - name: Login to Amazon ECR
        id: login-ecr
        uses: aws-actions/amazon-ecr-login@v1
      
      - name: Build, tag, and push image to Amazon ECR
        env:
          ECR_REGISTRY: ${{ steps.login-ecr.outputs.registry }}
          ECR_REPOSITORY: my-app
          IMAGE_TAG: ${{ github.sha }}
        run: |
          docker build -t $ECR_REGISTRY/$ECR_REPOSITORY:$IMAGE_TAG .
          docker push $ECR_REGISTRY/$ECR_REPOSITORY:$IMAGE_TAG
```

## Troubleshooting

### Common Issues

1. **Authentication failures** - Check IAM permissions and AWS credentials
2. **Image push failures** - Verify repository exists and has correct permissions
3. **Cross-account access issues** - Review repository policies
4. **Lifecycle policy not working** - Check policy syntax and rule priorities

### Debugging Commands

```bash
# List ECR repositories
aws ecr describe-repositories

# Get repository policy
aws ecr get-repository-policy --repository-name my-repo

# List images in repository
aws ecr list-images --repository-name my-repo

# Get image scan results
aws ecr describe-image-scan-findings --repository-name my-repo --image-id imageTag=latest

# Get lifecycle policy
aws ecr get-lifecycle-policy --repository-name my-repo

# Test lifecycle policy
aws ecr get-lifecycle-policy-preview --repository-name my-repo
```

## License

This module is released under the MIT License. See LICENSE file for details.