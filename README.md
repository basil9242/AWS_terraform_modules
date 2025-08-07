# AWS Infrastructure Modules

A comprehensive collection of reusable Infrastructure as Code modules for AWS.

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

### 5. ECS Module (`ECS/`)

Creates ECS clusters and services with comprehensive container orchestration features.

**Features:**
- ECS clusters with Container Insights
- ECS services with Fargate and EC2 launch types
- Auto scaling (CPU, memory, request-based)
- Service discovery with AWS Cloud Map
- Load balancer integration
- KMS encrypted logging
- ECS Exec for debugging
- Deployment circuit breakers
- Capacity providers support

**Usage:**
```hcl
module "ecs_service" {
  source = "./ECS"
  
  # Cluster Configuration
  cluster_name = "my-app-cluster"
  
  # Service Configuration
  service_name  = "web-service"
  desired_count = 2
  launch_type   = "FARGATE"
  
  # Network Configuration
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnet_ids
  
  # Task Definition
  task_definition_family = "web-app"
  task_cpu              = "512"
  task_memory           = "1024"
  
  # Container Configuration
  container_name  = "web-app"
  container_image = "nginx:latest"
  container_port  = 80
  
  # Auto Scaling
  enable_autoscaling      = true
  autoscaling_min_capacity = 1
  autoscaling_max_capacity = 10
  
  # Service Discovery
  enable_service_discovery         = true
  create_service_discovery_namespace = true
  service_discovery_namespace_name = "my-app.local"
  service_discovery_service_name   = "web-service"
  
  tags = {
    Environment = "prod"
    Application = "web-app"
  }
}
```

### 6. Load Balancer Module (`load_balancer/`)

Creates AWS Application Load Balancer (ALB) with target groups, listeners, and advanced routing capabilities.

**Features:**
- Application Load Balancer with customizable configuration
- Multiple target groups with health checks
- HTTP and HTTPS listeners with SSL termination
- Advanced routing with listener rules
- Session stickiness configuration
- Access logging to S3
- Cross-zone load balancing
- Target group attachments
- CloudWatch metrics integration

**Usage:**
```hcl
module "load_balancer" {
  source = "./load_balancer"

  name            = "my-app-alb"
  security_groups = [aws_security_group.alb.id]
  subnets         = module.vpc.public_subnet_ids
  vpc_id          = module.vpc.vpc_id

  # HTTPS Configuration
  enable_https_listener  = true
  http_redirect_to_https = true
  certificate_arn        = aws_acm_certificate.main.arn
  ssl_policy            = "ELBSecurityPolicy-TLS-1-2-2017-01"

  # Target Groups
  target_groups = [{
    name     = "web-servers"
    port     = 80
    protocol = "HTTP"
    health_check = {
      enabled             = true
      healthy_threshold   = 2
      interval            = 30
      matcher             = "200"
      path                = "/health"
      port                = "traffic-port"
      protocol            = "HTTP"
      timeout             = 5
      unhealthy_threshold = 2
    }
    stickiness = {
      type            = "lb_cookie"
      cookie_duration = 86400
      enabled         = false
    }
  }]

  # Access Logging
  access_logs_enabled = true
  access_logs_bucket  = aws_s3_bucket.alb_logs.bucket
  access_logs_prefix  = "alb-logs"

  tags = {
    Environment = "prod"
    Application = "web-app"
  }
}
```

### 7. S3 Bucket Public Read Prohibited Module (`s3-bucket-public-read-prohibited/`)

Creates AWS Config rule to monitor and ensure S3 buckets are not publicly readable, helping maintain security compliance.

**Features:**
- AWS Config rule implementation (`S3_BUCKET_PUBLIC_READ_PROHIBITED`)
- Configuration recorder for S3 bucket monitoring
- IAM role and policies for AWS Config service
- Compliance monitoring and reporting
- Security compliance automation
- Integration with CloudWatch for alerting

**Usage:**
```hcl
module "s3_public_read_prohibited" {
  source = "./s3-bucket-public-read-prohibited"
  
  config_rule_name          = "s3-bucket-public-read-prohibited"
  config_rule_recorder_name = "s3-bucket-recorder"
}
```


## Best Practices Implemented

### Security
- KMS encryption for all storage resources
- IMDSv2 enforcement for EC2 instances
- Public access blocking for S3 buckets
- Least privilege IAM policies
- Security groups with specific rules
- AWS Config rules for compliance monitoring
- Automated security compliance checks

### Monitoring & Logging
- VPC Flow Logs
- CloudWatch Log Groups with retention
- Optional detailed monitoring for EC2
- Metric filters for log analysis
- ECS Container Insights for container metrics
- ECS Exec for container debugging
- AWS Config compliance monitoring
- Security compliance dashboards

### Resource Management
- Comprehensive tagging strategy
- Lifecycle policies for cost optimization
- Proper resource dependencies
- Validation for critical variables

### High Availability
- Multi-AZ subnet deployment
- NAT Gateways for redundancy
- Auto-scaling friendly configurations
- ECS services with auto scaling and health checks
- Load balancer integration for high availability
- Service discovery for microservices communication


### For AWS Config Modules
- AWS Config service enabled
- Appropriate IAM permissions for Config service
- S3 bucket for Config delivery channel (if not already configured)

## Contributing

1. Follow the established module structure
2. Add variable validation where appropriate
3. Include comprehensive outputs
4. Update documentation
5. Test modules before submitting
