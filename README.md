# AWS Terraform Modules

A collection of reusable Terraform modules for AWS infrastructure components.

## Modules

### 1. CloudWatch Logs Module (`cloudwatch_logs/`)

Creates CloudWatch Log Groups with KMS encryption, optional log streams, metric filters, and subscription filters.

**Features:**
- KMS encrypted log groups
- Configurable retention periods
- Log streams creation
- Metric filters for monitoring
- Log subscription filters for streaming
- Cross-account log destinations

**Usage:**
```hcl
module "cloudwatch_logs" {
  source = "./cloudwatch_logs"
  
  cloudwatch_log_group_name = "my-application-logs"
  logs_retention_in_days    = 30
  environment              = "prod"
  
  tags = {
    Project = "MyProject"
    Owner   = "DevOps"
  }
}
```

### 2. VPC Module (`VPC/`)

Creates a complete VPC with public/private subnets, internet gateway, NAT gateways, and flow logs.

**Features:**
- Public and private subnets across multiple AZs
- Internet Gateway for public subnet access
- NAT Gateways for private subnet internet access
- VPC Flow Logs with CloudWatch integration
- Route tables and associations
- Comprehensive tagging

**Usage:**
```hcl
module "vpc" {
  source = "./VPC"
  
  vpc_name       = "my-vpc"
  cidr_block_vpc = "10.0.0.0/16"
  
  public_subnet = [
    {
      name              = "public-subnet-1"
      cidr_block        = "10.0.1.0/24"
      availability_zone = "us-west-2a"
    }
  ]
  
  private_subnet = [
    {
      name              = "private-subnet-1"
      cidr_block        = "10.0.2.0/24"
      availability_zone = "us-west-2a"
    }
  ]
  
  tags = {
    Environment = "prod"
  }
}
```

### 3. S3 Module (`s3/`)

Creates S3 buckets with comprehensive security features and optional configurations.

**Features:**
- KMS encryption
- Versioning configuration
- Public access blocking
- Lifecycle policies
- Access logging
- Bucket notifications (Lambda, SNS, SQS)
- CORS configuration
- Website hosting

**Usage:**
```hcl
module "s3_bucket" {
  source = "./s3"
  
  bucket_name = "my-secure-bucket"
  environment = "prod"
  
  enable_lifecycle_configuration = true
  lifecycle_rules = [
    {
      id     = "delete-old-versions"
      status = "Enabled"
      noncurrent_version_expiration = {
        days = 30
      }
    }
  ]
  
  tags = {
    Project = "MyProject"
  }
}
```

### 4. EC2 Module (`EC2/`)

Creates EC2 instances with security groups, IAM roles, and EBS volumes.

**Features:**
- KMS encrypted EBS volumes
- Security groups with configurable rules
- IAM instance profiles and roles
- Key pair management
- User data support
- Detailed monitoring option
- IMDSv2 enforcement

**Usage:**
```hcl
module "ec2_instance" {
  source = "./EC2"
  
  instance_name = "web-server"
  instance_ami  = "ami-0c02fb55956c7d316"
  instance_type = "t3.micro"
  subnet_id     = module.vpc.private_subnet_ids[0]
  vpc_id        = module.vpc.vpc_id
  
  security_group_name         = "web-server-sg"
  security_group_inbound_port = ["80", "443"]
  sg_ip_protocol             = "tcp"
  vpc_ipv4_cidr_block        = "10.0.0.0/16"
  
  tags = {
    Environment = "prod"
  }
}
```

## Best Practices Implemented

### Security
- KMS encryption for all storage resources
- IMDSv2 enforcement for EC2 instances
- Public access blocking for S3 buckets
- Least privilege IAM policies
- Security groups with specific rules

### Monitoring & Logging
- VPC Flow Logs
- CloudWatch Log Groups with retention
- Optional detailed monitoring for EC2
- Metric filters for log analysis

### Resource Management
- Comprehensive tagging strategy
- Lifecycle policies for cost optimization
- Proper resource dependencies
- Validation for critical variables

### High Availability
- Multi-AZ subnet deployment
- NAT Gateways for redundancy
- Auto-scaling friendly configurations

## Module Structure

Each module follows a consistent structure:
```
module_name/
├── main.tf              # Primary resources
├── variables.tf         # Input variables with validation
├── outputs.tf          # Output values
├── providers.tf        # Provider requirements
├── kms.tf             # KMS key resources
├── additional_resources.tf  # Feature-specific resources
└── README.md          # Module documentation
```

## Requirements

- Terraform >= 1.0
- AWS Provider ~> 5.0
- Appropriate AWS credentials and permissions

## Contributing

1. Follow the established module structure
2. Add variable validation where appropriate
3. Include comprehensive outputs
4. Update documentation
5. Test modules before submitting

## License

This project is licensed under the MIT License.