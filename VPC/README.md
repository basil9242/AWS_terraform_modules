# AWS VPC Terraform Module

A comprehensive Terraform module for creating and managing AWS VPC resources with best practices, including subnets, gateways, route tables, and VPC Flow Logs.

## Features

- ✅ **Complete VPC Setup** with public and private subnets
- ✅ **Internet Gateway** for public internet access
- ✅ **NAT Gateways** for private subnet internet access
- ✅ **Route Tables** with proper associations
- ✅ **VPC Flow Logs** with CloudWatch integration
- ✅ **KMS Encryption** for flow logs
- ✅ **Multi-AZ Support** for high availability
- ✅ **Comprehensive Tagging** support
- ✅ **Variable Validation** for input safety

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                          VPC                                │
│  ┌─────────────────┐              ┌─────────────────┐       │
│  │  Public Subnet  │              │  Public Subnet  │       │
│  │      AZ-1       │              │      AZ-2       │       │
│  │  ┌───────────┐  │              │  ┌───────────┐  │       │
│  │  │    NAT    │  │              │  │    NAT    │  │       │
│  │  │  Gateway  │  │              │  │  Gateway  │  │       │
│  │  └───────────┘  │              │  └───────────┘  │       │
│  └─────────────────┘              └─────────────────┘       │
│           │                                 │               │
│  ┌─────────────────┐              ┌─────────────────┐       │
│  │ Private Subnet  │              │ Private Subnet  │       │
│  │      AZ-1       │              │      AZ-2       │       │
│  └─────────────────┘              └─────────────────┘       │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │              Internet Gateway                       │   │
│  └─────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

## Usage

### Basic VPC Setup

```hcl
module "vpc" {
  source = "git::https://github.com/basil9242/AWS_terraform_modules.git//VPC"
  
  # VPC Configuration
  vpc_name       = "my-vpc"
  cidr_block_vpc = "10.0.0.0/16"
  
  # Subnets
  public_subnet = [
    {
      name              = "public-subnet-1"
      cidr_block        = "10.0.1.0/24"
      availability_zone = "us-east-1a"
    },
    {
      name              = "public-subnet-2"
      cidr_block        = "10.0.2.0/24"
      availability_zone = "us-east-1b"
    }
  ]
  
  private_subnet = [
    {
      name              = "private-subnet-1"
      cidr_block        = "10.0.10.0/24"
      availability_zone = "us-east-1a"
    },
    {
      name              = "private-subnet-2"
      cidr_block        = "10.0.20.0/24"
      availability_zone = "us-east-1b"
    }
  ]
  
  tags = {
    Environment = "production"
    Project     = "my-project"
  }
}
```

### Advanced VPC with All Features

```hcl
module "vpc" {
  source = "git::https://github.com/basil9242/AWS_terraform_modules.git//VPC"
  
  # VPC Configuration
  vpc_name             = "production-vpc"
  cidr_block_vpc       = "10.0.0.0/16"
  vpc_instance_tenancy = "default"
  
  # DNS Configuration
  enable_dns_hostnames = true
  enable_dns_support   = true
  
  # Gateway Configuration
  create_internet_gateway = true
  create_nat_gateway      = true
  
  # Flow Logs Configuration
  enable_flow_logs           = true
  flow_logs_retention_days   = 30
  vpc_cloudwatch_logs_group_name = "vpc-flow-logs"
  vpc_logs_role_name         = "vpc-flow-logs-role"
  
  # Public Subnets (Multi-AZ)
  public_subnet = [
    {
      name              = "public-web-1a"
      cidr_block        = "10.0.1.0/24"
      availability_zone = "us-east-1a"
    },
    {
      name              = "public-web-1b"
      cidr_block        = "10.0.2.0/24"
      availability_zone = "us-east-1b"
    },
    {
      name              = "public-web-1c"
      cidr_block        = "10.0.3.0/24"
      availability_zone = "us-east-1c"
    }
  ]
  
  # Private Subnets (Multi-AZ)
  private_subnet = [
    {
      name              = "private-app-1a"
      cidr_block        = "10.0.10.0/24"
      availability_zone = "us-east-1a"
    },
    {
      name              = "private-app-1b"
      cidr_block        = "10.0.20.0/24"
      availability_zone = "us-east-1b"
    },
    {
      name              = "private-db-1a"
      cidr_block        = "10.0.30.0/24"
      availability_zone = "us-east-1a"
    },
    {
      name              = "private-db-1b"
      cidr_block        = "10.0.40.0/24"
      availability_zone = "us-east-1b"
    }
  ]
  
  # Tagging
  environment = "production"
  tags = {
    Owner        = "platform-team"
    CostCenter   = "infrastructure"
    Compliance   = "required"
    Backup       = "daily"
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
| `aws_vpc` | Main VPC with DNS configuration |
| `aws_subnet` | Public and private subnets across AZs |
| `aws_internet_gateway` | Internet gateway for public access |
| `aws_nat_gateway` | NAT gateways for private subnet internet access |
| `aws_eip` | Elastic IPs for NAT gateways |
| `aws_route_table` | Route tables for public and private subnets |
| `aws_route_table_association` | Route table associations |
| `aws_flow_log` | VPC Flow Logs (optional) |
| `aws_cloudwatch_log_group` | CloudWatch log group for flow logs |
| `aws_kms_key` | KMS key for flow log encryption |
| `aws_iam_role` | IAM role for flow logs |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `vpc_name` | Name of the VPC | `string` | n/a | yes |
| `cidr_block_vpc` | CIDR block for VPC | `string` | n/a | yes |
| `public_subnet` | Public subnet configurations | `list(object)` | `[]` | no |
| `private_subnet` | Private subnet configurations | `list(object)` | `[]` | no |
| `vpc_instance_tenancy` | VPC instance tenancy | `string` | `"default"` | no |
| `enable_dns_hostnames` | Enable DNS hostnames | `bool` | `true` | no |
| `enable_dns_support` | Enable DNS support | `bool` | `true` | no |
| `create_internet_gateway` | Create Internet Gateway | `bool` | `true` | no |
| `create_nat_gateway` | Create NAT Gateways | `bool` | `true` | no |
| `enable_flow_logs` | Enable VPC Flow Logs | `bool` | `true` | no |
| `flow_logs_retention_days` | Flow logs retention period | `number` | `30` | no |
| `vpc_cloudwatch_logs_group_name` | CloudWatch log group name for flow logs | `string` | n/a | yes (if flow logs enabled) |
| `vpc_logs_role_name` | IAM role name for flow logs | `string` | n/a | yes (if flow logs enabled) |
| `tags` | Resource tags | `map(string)` | `{}` | no |
| `environment` | Environment name | `string` | `"dev"` | no |

## Outputs

| Name | Description |
|------|-------------|
| `vpc_id` | VPC ID |
| `vpc_arn` | VPC ARN |
| `vpc_cidr_block` | VPC CIDR block |
| `public_subnet_ids` | List of public subnet IDs |
| `private_subnet_ids` | List of private subnet IDs |
| `public_subnet_arns` | List of public subnet ARNs |
| `private_subnet_arns` | List of private subnet ARNs |
| `internet_gateway_id` | Internet Gateway ID |
| `nat_gateway_ids` | List of NAT Gateway IDs |
| `nat_gateway_public_ips` | List of NAT Gateway public IPs |
| `public_route_table_id` | Public route table ID |
| `private_route_table_ids` | List of private route table IDs |
| `vpc_flow_log_id` | VPC Flow Log ID |
| `vpc_flow_log_cloudwatch_log_group_name` | CloudWatch log group name for flow logs |

## Examples

### Three-Tier Architecture

```hcl
module "three_tier_vpc" {
  source = "git::https://github.com/basil9242/AWS_terraform_modules.git//VPC"
  
  vpc_name       = "three-tier-vpc"
  cidr_block_vpc = "10.0.0.0/16"
  
  # Web Tier (Public Subnets)
  public_subnet = [
    {
      name              = "web-tier-1a"
      cidr_block        = "10.0.1.0/24"
      availability_zone = "us-east-1a"
    },
    {
      name              = "web-tier-1b"
      cidr_block        = "10.0.2.0/24"
      availability_zone = "us-east-1b"
    }
  ]
  
  # App Tier + DB Tier (Private Subnets)
  private_subnet = [
    # Application Tier
    {
      name              = "app-tier-1a"
      cidr_block        = "10.0.10.0/24"
      availability_zone = "us-east-1a"
    },
    {
      name              = "app-tier-1b"
      cidr_block        = "10.0.20.0/24"
      availability_zone = "us-east-1b"
    },
    # Database Tier
    {
      name              = "db-tier-1a"
      cidr_block        = "10.0.30.0/24"
      availability_zone = "us-east-1a"
    },
    {
      name              = "db-tier-1b"
      cidr_block        = "10.0.40.0/24"
      availability_zone = "us-east-1b"
    }
  ]
  
  tags = {
    Architecture = "three-tier"
    Environment  = "production"
  }
}
```

### Development VPC (Cost Optimized)

```hcl
module "dev_vpc" {
  source = "git::https://github.com/basil9242/AWS_terraform_modules.git//VPC"
  
  vpc_name       = "dev-vpc"
  cidr_block_vpc = "10.1.0.0/16"
  
  # Single AZ for cost optimization
  public_subnet = [
    {
      name              = "dev-public"
      cidr_block        = "10.1.1.0/24"
      availability_zone = "us-east-1a"
    }
  ]
  
  private_subnet = [
    {
      name              = "dev-private"
      cidr_block        = "10.1.10.0/24"
      availability_zone = "us-east-1a"
    }
  ]
  
  # Disable NAT Gateway for cost savings
  create_nat_gateway = false
  
  # Shorter retention for dev environment
  flow_logs_retention_days = 7
  
  environment = "development"
  tags = {
    CostOptimized = "true"
    AutoShutdown  = "enabled"
  }
}
```

## Best Practices

1. **Use multiple AZs** - Ensure high availability across availability zones
2. **Plan CIDR blocks carefully** - Avoid overlapping with other VPCs or on-premises networks
3. **Enable VPC Flow Logs** - Monitor network traffic for security and troubleshooting
4. **Use consistent naming** - Follow naming conventions for easy resource identification
5. **Implement proper tagging** - Enable cost allocation and resource management
6. **Consider NAT Gateway costs** - Use single NAT Gateway for dev environments
7. **Enable DNS hostnames** - Required for many AWS services

## Security Considerations

- VPC Flow Logs are encrypted with KMS
- Private subnets have no direct internet access
- NAT Gateways provide controlled outbound internet access
- Security groups and NACLs should be configured separately
- Consider VPC endpoints for AWS services to avoid internet routing

## Cost Optimization

- Use single NAT Gateway for development environments
- Consider NAT instances for very low traffic scenarios
- Implement appropriate flow log retention periods
- Use resource tagging for cost allocation
- Monitor data transfer costs between AZs

## Troubleshooting

### Common Issues

1. **CIDR block conflicts** - Ensure no overlap with existing VPCs
2. **Route table misconfigurations** - Verify routes are properly associated
3. **NAT Gateway connectivity** - Check security groups and NACLs
4. **DNS resolution issues** - Ensure DNS hostnames and support are enabled

### Debugging Commands

```bash
# Check VPC configuration
aws ec2 describe-vpcs --vpc-ids vpc-xxxxxxxxx

# Check route tables
aws ec2 describe-route-tables --filters "Name=vpc-id,Values=vpc-xxxxxxxxx"

# Check NAT Gateway status
aws ec2 describe-nat-gateways --filter "Name=vpc-id,Values=vpc-xxxxxxxxx"

# Check VPC Flow Logs
aws logs describe-log-groups --log-group-name-prefix vpc-flow-logs
```

