# AWS EC2 Terraform Module

A comprehensive Terraform module for creating and managing AWS EC2 instances with advanced security features, EBS volumes, IAM roles, security groups, and key pair management.

## Features

- ✅ **EC2 Instances** with customizable configurations
- ✅ **EBS Volumes** with KMS encryption (root and additional)
- ✅ **Security Groups** with configurable ingress rules
- ✅ **IAM Roles & Instance Profiles** for secure access
- ✅ **Key Pairs** with TLS private key generation
- ✅ **User Data** support for instance initialization
- ✅ **KMS Encryption** for EBS volumes
- ✅ **IMDSv2** enforcement for enhanced security
- ✅ **Comprehensive Tagging** support
- ✅ **Variable Validation** for input safety

## Usage

### Basic EC2 Instance

```hcl
module "ec2_instance" {
  source = "git::https://github.com/basil9242/AWS_terraform_modules.git//EC2"
  
  # Instance Configuration
  instance_name = "my-web-server"
  instance_ami  = "ami-0abcdef1234567890"  # Amazon Linux 2023
  instance_type = "t3.micro"
  
  # Network Configuration
  subnet_id                   = "subnet-12345678"
  vpc_id                      = "vpc-12345678"
  associate_public_ip_address = true
  availability_zone           = "us-east-1a"
  
  # Security
  security_group_name         = "web-server-sg"
  security_group_inbound_port = ["22", "80", "443"]
  sg_ip_protocol              = "tcp"
  vpc_ipv4_cidr_block         = "10.0.0.0/16"
  
  # Storage
  root_volume_size               = "20"
  root_ebs_volume_type           = "gp3"
  root_ebs_encryption            = true
  root_ebs_delete_on_termination = true
  
  # Key Pair
  key_pair_name = "my-web-server-key"
  
  tags = {
    Environment = "production"
    Application = "web-server"
  }
}
```

### Advanced EC2 Instance with All Features

```hcl
module "ec2_instance" {
  source = "git::https://github.com/basil9242/AWS_terraform_modules.git//EC2"
  
  # Instance Configuration
  instance_name = "advanced-app-server"
  instance_ami  = "ami-0abcdef1234567890"
  instance_type = "t3.medium"
  
  # Network Configuration
  subnet_id                   = "subnet-12345678"
  vpc_id                      = "vpc-12345678"
  associate_public_ip_address = false
  availability_zone           = "us-east-1a"
  vpc_ipv4_cidr_block         = "10.0.0.0/16"
  
  # Security Group Configuration
  security_group_name         = "app-server-sg"
  security_group_inbound_port = ["22", "8080", "8443"]
  sg_ip_protocol              = "tcp"
  
  # Root EBS Volume
  root_volume_size               = "50"
  root_ebs_volume_type           = "gp3"
  root_ebs_encryption            = true
  root_ebs_delete_on_termination = true
  root_ebs_iops                  = "3000"
  root_ebs_throughput            = "125"
  root_ebs_volume_name           = "app-server-root"
  
  # Additional EBS Volume
  attach_ebs_required_or_not = true
  ebs_device_name            = "/dev/sdf"
  ebs_volume_size            = "100"
  ebs_volume_type            = "gp3"
  ebs_encryption             = true
  ebs_availability_zone      = "us-east-1a"
  ebs_iops                   = "3000"
  ebs_throughput             = "125"
  ebs_final_snapshot         = true
  
  # IAM Role Configuration
  attach_role_instance    = true
  instance_profile_name   = "app-server-profile"
  instance_role_name      = "app-server-role"
  iam_policy_json_file    = true
  iam_policy_json_file_path = "./policies/app-server-policy.json"
  
  # Key Pair
  key_pair_name = "app-server-key"
  
  # User Data
  user_data_required_or_not = true
  ec2_userdata_file_path    = "./userdata/app-server-init.sh"
  
  tags = {
    Environment = "production"
    Application = "app-server"
    Owner       = "platform-team"
    CostCenter  = "engineering"
  }
}
```

### Multiple EC2 Instances

```hcl
module "web_servers" {
  source = "git::https://github.com/basil9242/AWS_terraform_modules.git//EC2"
  
  for_each = {
    web1 = { az = "us-east-1a", subnet = "subnet-12345678" }
    web2 = { az = "us-east-1b", subnet = "subnet-87654321" }
    web3 = { az = "us-east-1c", subnet = "subnet-11111111" }
  }
  
  # Instance Configuration
  instance_name = "web-server-${each.key}"
  instance_ami  = "ami-0abcdef1234567890"
  instance_type = "t3.small"
  
  # Network Configuration
  subnet_id                   = each.value.subnet
  availability_zone           = each.value.az
  associate_public_ip_address = true
  vpc_id                      = "vpc-12345678"
  vpc_ipv4_cidr_block         = "10.0.0.0/16"
  
  # Security
  security_group_name         = "web-server-sg-${each.key}"
  security_group_inbound_port = ["22", "80", "443"]
  sg_ip_protocol              = "tcp"
  
  # Storage
  root_volume_size    = "20"
  root_ebs_encryption = true
  
  # Key Pair
  key_pair_name = "web-server-${each.key}-key"
  
  tags = {
    Environment = "production"
    Server      = each.key
    Role        = "web-server"
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| aws | ~> 5.0 |
| tls | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| aws | ~> 5.0 |
| tls | ~> 4.0 |

## Resources Created

| Resource | Description |
|----------|-------------|
| `aws_instance` | EC2 instance with security configurations |
| `aws_ebs_volume` | Additional EBS volume (optional) |
| `aws_volume_attachment` | EBS volume attachment (optional) |
| `aws_security_group` | Security group with ingress rules |
| `aws_vpc_security_group_ingress_rule` | Security group ingress rules |
| `aws_key_pair` | EC2 key pair for SSH access |
| `aws_iam_role` | IAM role for EC2 instance (optional) |
| `aws_iam_instance_profile` | IAM instance profile (optional) |
| `aws_iam_policy` | Custom IAM policy (optional) |
| `aws_iam_role_policy_attachment` | Policy attachments |
| `aws_kms_key` | KMS key for EBS encryption |
| `aws_kms_key_policy` | KMS key policy |
| `tls_private_key` | TLS private key for key pair |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `instance_name` | Name of the EC2 instance | `string` | n/a | yes |
| `instance_ami` | AMI ID for the instance | `string` | n/a | yes |
| `instance_type` | Instance type | `string` | n/a | yes |
| `subnet_id` | Subnet ID to launch instance | `string` | n/a | yes |
| `vpc_id` | VPC ID | `string` | n/a | yes |
| `availability_zone` | Availability zone | `string` | n/a | yes |
| `associate_public_ip_address` | Associate public IP | `bool` | `false` | no |
| `security_group_name` | Security group name | `string` | n/a | yes |
| `security_group_inbound_port` | Inbound ports | `set(string)` | `[]` | no |
| `sg_ip_protocol` | IP protocol for security group | `string` | `"tcp"` | no |
| `vpc_ipv4_cidr_block` | VPC CIDR block for security group | `string` | n/a | yes |
| `root_volume_size` | Root volume size in GB | `string` | `"8"` | no |
| `root_ebs_volume_type` | Root volume type | `string` | `"gp3"` | no |
| `root_ebs_encryption` | Enable root volume encryption | `bool` | `true` | no |
| `root_ebs_delete_on_termination` | Delete root volume on termination | `bool` | `true` | no |
| `root_ebs_iops` | Root volume IOPS | `string` | `null` | no |
| `root_ebs_throughput` | Root volume throughput | `string` | `null` | no |
| `root_ebs_volume_name` | Root volume name | `string` | `null` | no |
| `attach_ebs_required_or_not` | Attach additional EBS volume | `bool` | `false` | no |
| `ebs_device_name` | Device name for additional EBS | `string` | `null` | no |
| `ebs_volume_size` | Additional EBS volume size | `string` | `null` | no |
| `ebs_volume_type` | Additional EBS volume type | `string` | `"gp3"` | no |
| `ebs_encryption` | Enable additional EBS encryption | `bool` | `true` | no |
| `ebs_availability_zone` | AZ for additional EBS volume | `string` | `null` | no |
| `ebs_iops` | Additional EBS volume IOPS | `string` | `null` | no |
| `ebs_throughput` | Additional EBS volume throughput | `string` | `null` | no |
| `ebs_final_snapshot` | Create final snapshot | `bool` | `false` | no |
| `attach_role_instance` | Attach IAM role to instance | `bool` | `false` | no |
| `instance_profile_name` | IAM instance profile name | `string` | `null` | no |
| `instance_role_name` | IAM role name | `string` | `null` | no |
| `iam_policy_json_file` | Use JSON file for IAM policy | `bool` | `false` | no |
| `iam_policy_json_file_path` | Path to IAM policy JSON file | `string` | `null` | no |
| `policy_arn` | ARN of existing policy to attach | `string` | `null` | no |
| `key_pair_name` | Name of the key pair | `string` | n/a | yes |
| `user_data_required_or_not` | Enable user data | `bool` | `false` | no |
| `ec2_userdata_file_path` | Path to user data script | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| `instance_id` | EC2 instance ID |
| `instance_arn` | EC2 instance ARN |
| `instance_public_ip` | Public IP address |
| `instance_private_ip` | Private IP address |
| `instance_public_dns` | Public DNS name |
| `instance_private_dns` | Private DNS name |
| `security_group_id` | Security group ID |
| `key_pair_name` | Key pair name |
| `private_key_pem` | Private key in PEM format (sensitive) |
| `ebs_volume_id` | Additional EBS volume ID |
| `iam_role_arn` | IAM role ARN |

## Examples

### Web Server with Load Balancer

```hcl
module "web_server" {
  source = "git::https://github.com/basil9242/AWS_terraform_modules.git//EC2"
  
  instance_name = "web-server"
  instance_ami  = data.aws_ami.amazon_linux.id
  instance_type = "t3.small"
  
  # Network
  subnet_id                   = module.vpc.private_subnet_ids[0]
  vpc_id                      = module.vpc.vpc_id
  associate_public_ip_address = false
  availability_zone           = "us-east-1a"
  vpc_ipv4_cidr_block         = "10.0.0.0/16"
  
  # Security - Only allow ALB access
  security_group_name         = "web-server-sg"
  security_group_inbound_port = ["80", "443"]
  sg_ip_protocol              = "tcp"
  
  # IAM Role for CloudWatch and SSM
  attach_role_instance  = true
  instance_profile_name = "web-server-profile"
  instance_role_name    = "web-server-role"
  policy_arn           = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  
  # User Data for Application Setup
  user_data_required_or_not = true
  ec2_userdata_file_path    = "./scripts/web-server-setup.sh"
  
  # Storage
  root_volume_size    = "20"
  root_ebs_encryption = true
  
  key_pair_name = "web-server-key"
  
  tags = {
    Role        = "web-server"
    Environment = "production"
    Backup      = "daily"
  }
}
```

### Database Server

```hcl
module "database_server" {
  source = "git::https://github.com/basil9242/AWS_terraform_modules.git//EC2"
  
  instance_name = "database-server"
  instance_ami  = data.aws_ami.amazon_linux.id
  instance_type = "r5.large"  # Memory optimized
  
  # Network - Private subnet only
  subnet_id                   = module.vpc.private_subnet_ids[0]
  vpc_id                      = module.vpc.vpc_id
  associate_public_ip_address = false
  availability_zone           = "us-east-1a"
  vpc_ipv4_cidr_block         = "10.0.0.0/16"
  
  # Security - Database ports
  security_group_name         = "database-sg"
  security_group_inbound_port = ["3306", "5432"]
  sg_ip_protocol              = "tcp"
  
  # Storage - Large root volume + separate data volume
  root_volume_size               = "50"
  root_ebs_volume_type           = "gp3"
  root_ebs_encryption            = true
  
  attach_ebs_required_or_not = true
  ebs_device_name            = "/dev/sdf"
  ebs_volume_size            = "500"
  ebs_volume_type            = "io2"
  ebs_encryption             = true
  ebs_availability_zone      = "us-east-1a"
  ebs_iops                   = "10000"
  ebs_final_snapshot         = true
  
  # IAM Role for backups
  attach_role_instance    = true
  instance_profile_name   = "database-profile"
  instance_role_name      = "database-role"
  iam_policy_json_file    = true
  iam_policy_json_file_path = "./policies/database-backup-policy.json"
  
  key_pair_name = "database-key"
  
  tags = {
    Role        = "database"
    Environment = "production"
    Backup      = "continuous"
    Critical    = "true"
  }
}
```

### Development Instance

```hcl
module "dev_instance" {
  source = "git::https://github.com/basil9242/AWS_terraform_modules.git//EC2"
  
  instance_name = "dev-workstation"
  instance_ami  = data.aws_ami.ubuntu.id
  instance_type = "t3.medium"
  
  # Network - Public subnet for development
  subnet_id                   = module.vpc.public_subnet_ids[0]
  vpc_id                      = module.vpc.vpc_id
  associate_public_ip_address = true
  availability_zone           = "us-east-1a"
  vpc_ipv4_cidr_block         = "10.0.0.0/16"
  
  # Security - SSH and development ports
  security_group_name         = "dev-sg"
  security_group_inbound_port = ["22", "3000", "8080", "9000"]
  sg_ip_protocol              = "tcp"
  
  # Storage
  root_volume_size    = "100"
  root_ebs_encryption = true
  
  # IAM Role for development tools
  attach_role_instance  = true
  instance_profile_name = "dev-profile"
  instance_role_name    = "dev-role"
  policy_arn           = "arn:aws:iam::aws:policy/PowerUserAccess"
  
  # User Data for development tools
  user_data_required_or_not = true
  ec2_userdata_file_path    = "./scripts/dev-setup.sh"
  
  key_pair_name = "dev-key"
  
  tags = {
    Role        = "development"
    Environment = "dev"
    AutoStop    = "enabled"
    Owner       = "developer"
  }
}
```

## Best Practices

1. **Use IMDSv2** - Enforced by default for enhanced security
2. **Enable EBS encryption** - Protect data at rest
3. **Use IAM roles** - Avoid hardcoded credentials
4. **Implement least privilege** - Minimal security group rules
5. **Use private subnets** - For non-public facing instances
6. **Enable detailed monitoring** - For production workloads
7. **Implement proper tagging** - For cost allocation and management
8. **Use user data** - For automated instance configuration
9. **Regular patching** - Keep instances updated
10. **Backup strategies** - EBS snapshots and AMI creation

## Security Considerations

- IMDSv2 is enforced by default
- EBS volumes are encrypted with KMS
- Security groups follow least privilege principle
- IAM roles are used instead of access keys
- Private keys are generated securely with TLS provider
- User data scripts should not contain sensitive information

## Cost Optimization

- Use appropriate instance types for workload
- Enable EBS optimization only when needed
- Use Spot instances for non-critical workloads
- Implement auto-scaling for variable workloads
- Monitor and right-size instances regularly
- Use reserved instances for predictable workloads

## Monitoring and Logging

- Enable CloudWatch detailed monitoring
- Install CloudWatch agent for custom metrics
- Use AWS Systems Manager for patch management
- Implement log aggregation with CloudWatch Logs
- Set up alarms for critical metrics

## Troubleshooting

### Common Issues

1. **Instance launch failures** - Check subnet capacity and limits
2. **SSH connection issues** - Verify security groups and key pairs
3. **EBS attachment failures** - Check availability zone matching
4. **IAM permission errors** - Verify role policies and trust relationships

### Debugging Commands

```bash
# Check instance status
aws ec2 describe-instances --instance-ids i-1234567890abcdef0

# View instance console output
aws ec2 get-console-output --instance-id i-1234567890abcdef0

# Check security groups
aws ec2 describe-security-groups --group-ids sg-1234567890abcdef0

# Verify IAM role
aws iam get-role --role-name my-instance-role

# Check EBS volumes
aws ec2 describe-volumes --filters "Name=attachment.instance-id,Values=i-1234567890abcdef0"
```

