# AWS IAM User Terraform Module

A comprehensive Terraform module for creating and managing AWS IAM users with advanced security features including MFA, encrypted passwords, access keys, and group management.

## Features

- ✅ **IAM Users** with secure password generation
- ✅ **IAM Groups** with policy attachments
- ✅ **MFA Virtual Devices** for enhanced security
- ✅ **Access Keys** with PGP encryption
- ✅ **Login Profiles** with encrypted passwords
- ✅ **Policy Management** (JSON files and ARNs)
- ✅ **Group Membership** management
- ✅ **Comprehensive Tagging** support
- ✅ **Variable Validation** for input safety

## Features Overview

### Security Features
- **MFA Enforcement**: Virtual MFA devices for two-factor authentication
- **Encrypted Passwords**: PGP-encrypted login passwords
- **Secure Access Keys**: Encrypted access keys for programmatic access
- **Policy-based Access**: Fine-grained permissions through IAM policies

### Management Features
- **Group-based Organization**: Organize users into logical groups
- **Flexible Policy Attachment**: Support for both managed policies and custom JSON policies
- **Automated Password Generation**: Secure password generation with PGP encryption
- **Comprehensive Outputs**: Access to all created resources and credentials

## Usage

### Basic IAM User

```hcl
module "iam_user" {
  source = "git::https://github.com/basil9242/AWS_terraform_modules.git//IAM_User"
  
  # User Configuration
  iam_user_name  = "john.doe"
  iam_user_email = "john.doe@company.com"
  
  # Group Configuration
  iam_group_name = "developers"
  
  # Policy (using managed policy ARN)
  iam_policy_json_file = false
  group_policy_arn     = "arn:aws:iam::aws:policy/PowerUserAccess"
  
  # Tags
  iam_user_tags = {
    Department = "Engineering"
    Team       = "Backend"
    Role       = "Developer"
  }
}
```

### Advanced IAM User with Custom Policy

```hcl
module "iam_user_advanced" {
  source = "git::https://github.com/basil9242/AWS_terraform_modules.git//IAM_User"
  
  # User Configuration
  iam_user_name = "jane.smith"
  iam_user_email = "jane.smith@company.com"
  iam_user_path = "/developers/"
  
  # Group Configuration
  iam_group_name = "senior-developers"
  iam_group_path = "/teams/"
  iam_group_member_name = "senior-dev-members"
  
  # Custom Policy Configuration
  iam_policy_json_file = true
  iam_group_policy_json_file_path = "./policies/senior-developer-policy.json"
  
  # Additional managed policy
  group_policy_arn = "arn:aws:iam::aws:policy/IAMReadOnlyAccess"
  
  # MFA Configuration
  enable_mfa_device = true
  
  # Access Key Configuration
  create_access_key = true
  
  # Tags
  iam_user_tags = {
    Department   = "Engineering"
    Team         = "Platform"
    Role         = "Senior Developer"
    CostCenter   = "Engineering"
    Environment  = "production"
  }
}
```

### Multiple Users with Different Roles

```hcl
locals {
  users = {
    "alice.admin" = {
      email      = "alice@company.com"
      group      = "administrators"
      policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
      department = "IT"
      role       = "Administrator"
    }
    "bob.developer" = {
      email      = "bob@company.com"
      group      = "developers"
      policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
      department = "Engineering"
      role       = "Developer"
    }
    "carol.readonly" = {
      email      = "carol@company.com"
      group      = "readonly-users"
      policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
      department = "Finance"
      role       = "Analyst"
    }
  }
}

module "iam_users" {
  source = "git::https://github.com/basil9242/AWS_terraform_modules.git//IAM_User"
  
  for_each = local.users
  
  # User Configuration
  iam_user_name  = each.key
  iam_user_email = each.value.email
  
  # Group Configuration
  iam_group_name = each.value.group
  
  # Policy Configuration
  iam_policy_json_file = false
  group_policy_arn     = each.value.policy_arn
  
  # Security
  enable_mfa_device = true
  create_access_key = each.value.role == "Developer"
  
  # Tags
  iam_user_tags = {
    Department = each.value.department
    Role       = each.value.role
    ManagedBy  = "terraform"
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| aws | ~> 5.0 |
| pgp | ~> 0.2.4 |

## Providers

| Name | Version |
|------|---------|
| aws | ~> 5.0 |
| pgp | ~> 0.2.4 |

## Resources Created

| Resource | Description |
|----------|-------------|
| `aws_iam_user` | IAM user account |
| `aws_iam_user_login_profile` | Console login profile with encrypted password |
| `aws_iam_access_key` | Programmatic access keys (optional) |
| `aws_iam_group` | IAM group for organizing users |
| `aws_iam_group_membership` | Group membership assignment |
| `aws_iam_group_policy_attachment` | Managed policy attachments |
| `aws_iam_policy` | Custom IAM policies (optional) |
| `aws_iam_virtual_mfa_device` | Virtual MFA device (optional) |
| `pgp_key` | PGP key for password encryption |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `iam_user_name` | IAM user name | `string` | n/a | yes |
| `iam_user_email` | User email address | `string` | n/a | yes |
| `iam_user_path` | IAM user path | `string` | `"/"` | no |
| `iam_user_tags` | User tags | `map(string)` | `{}` | no |
| `iam_group_name` | IAM group name | `string` | n/a | yes |
| `iam_group_path` | IAM group path | `string` | `"/"` | no |
| `iam_group_member_name` | Group membership name | `string` | `"group-membership"` | no |
| `iam_policy_json_file` | Use JSON file for custom policy | `bool` | `false` | no |
| `iam_group_policy_json_file_path` | Path to custom policy JSON file | `string` | `null` | no |
| `group_policy_arn` | ARN of managed policy to attach | `string` | `null` | no |
| `enable_mfa_device` | Create virtual MFA device | `bool` | `false` | no |
| `create_access_key` | Create access keys for user | `bool` | `false` | no |
| `force_destroy` | Force destroy user even if it has non-Terraform-managed IAM access keys | `bool` | `false` | no |
| `password_reset_required` | Require password reset on first login | `bool` | `true` | no |
| `password_length` | Length of generated password | `number` | `20` | no |

## Outputs

| Name | Description |
|------|-------------|
| `iam_user_arn` | IAM user ARN |
| `iam_user_name` | IAM user name |
| `iam_user_unique_id` | IAM user unique ID |
| `iam_group_arn` | IAM group ARN |
| `iam_group_name` | IAM group name |
| `password_credentials` | Encrypted password credentials |
| `access_key_id` | Access key ID (if created) |
| `secret_access_key` | Encrypted secret access key (if created) |
| `mfa_device_arn` | MFA device ARN (if created) |
| `mfa_device_qr_code` | MFA device QR code for setup (if created) |
| `pgp_key_fingerprint` | PGP key fingerprint |

## Examples

### Development Team Setup

```hcl
# Custom policy for developers
data "aws_iam_policy_document" "developer_policy" {
  statement {
    effect = "Allow"
    actions = [
      "ec2:*",
      "s3:*",
      "lambda:*",
      "logs:*",
      "cloudwatch:*"
    ]
    resources = ["*"]
  }
  
  statement {
    effect = "Deny"
    actions = [
      "ec2:TerminateInstances",
      "s3:DeleteBucket"
    ]
    resources = ["*"]
    condition {
      test     = "StringNotEquals"
      variable = "aws:RequestedRegion"
      values   = ["us-east-1", "us-west-2"]
    }
  }
}

resource "local_file" "developer_policy" {
  content  = data.aws_iam_policy_document.developer_policy.json
  filename = "./policies/developer-policy.json"
}

module "dev_team_users" {
  source = "git::https://github.com/basil9242/AWS_terraform_modules.git//IAM_User"
  
  for_each = toset([
    "dev.alice",
    "dev.bob", 
    "dev.charlie"
  ])
  
  # User Configuration
  iam_user_name  = each.value
  iam_user_email = "${replace(each.value, ".", "@")}@company.com"
  iam_user_path  = "/developers/"
  
  # Group Configuration
  iam_group_name = "development-team"
  iam_group_path = "/teams/"
  
  # Custom Policy
  iam_policy_json_file = true
  iam_group_policy_json_file_path = local_file.developer_policy.filename
  
  # Security
  enable_mfa_device = true
  create_access_key = true
  
  # Tags
  iam_user_tags = {
    Team        = "Development"
    Environment = "development"
    ManagedBy   = "terraform"
    CostCenter  = "engineering"
  }
  
  depends_on = [local_file.developer_policy]
}
```

### Admin User with MFA

```hcl
module "admin_user" {
  source = "git::https://github.com/basil9242/AWS_terraform_modules.git//IAM_User"
  
  # User Configuration
  iam_user_name  = "admin.user"
  iam_user_email = "admin@company.com"
  iam_user_path  = "/administrators/"
  
  # Group Configuration
  iam_group_name = "administrators"
  iam_group_path = "/admin/"
  
  # Policy Configuration
  iam_policy_json_file = false
  group_policy_arn     = "arn:aws:iam::aws:policy/AdministratorAccess"
  
  # Security Configuration
  enable_mfa_device        = true
  create_access_key        = false  # No programmatic access for admin
  password_reset_required  = true
  password_length         = 32
  
  # Tags
  iam_user_tags = {
    Role        = "Administrator"
    Department  = "IT"
    Critical    = "true"
    MFARequired = "true"
  }
}

# Output the MFA setup instructions
output "admin_mfa_setup" {
  value = <<-EOT
    MFA Setup Instructions for ${module.admin_user.iam_user_name}:
    1. Install an authenticator app (Google Authenticator, Authy, etc.)
    2. Scan the QR code: ${module.admin_user.mfa_device_qr_code}
    3. Enter the 6-digit code from your app to complete setup
    4. MFA Device ARN: ${module.admin_user.mfa_device_arn}
  EOT
  sensitive = true
}
```

### Service Account User

```hcl
# Policy for service account
data "aws_iam_policy_document" "service_account_policy" {
  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject"
    ]
    resources = [
      "arn:aws:s3:::my-app-bucket/*"
    ]
  }
  
  statement {
    effect = "Allow"
    actions = [
      "sqs:SendMessage",
      "sqs:ReceiveMessage",
      "sqs:DeleteMessage"
    ]
    resources = [
      "arn:aws:sqs:*:*:my-app-queue"
    ]
  }
}

resource "local_file" "service_account_policy" {
  content  = data.aws_iam_policy_document.service_account_policy.json
  filename = "./policies/service-account-policy.json"
}

module "service_account" {
  source = "git::https://github.com/basil9242/AWS_terraform_modules.git//IAM_User"
  
  # User Configuration
  iam_user_name = "service-account-myapp"
  iam_user_email = "service-account@company.com"
  iam_user_path = "/service-accounts/"
  
  # Group Configuration
  iam_group_name = "service-accounts"
  iam_group_path = "/service/"
  
  # Custom Policy
  iam_policy_json_file = true
  iam_group_policy_json_file_path = local_file.service_account_policy.filename
  
  # Service accounts need programmatic access, not console access
  create_access_key = true
  enable_mfa_device = false  # Service accounts typically don't use MFA
  
  # Tags
  iam_user_tags = {
    Type        = "ServiceAccount"
    Application = "my-app"
    Environment = "production"
    Automated   = "true"
  }
  
  depends_on = [local_file.service_account_policy]
}
```

## Policy Examples

### Developer Policy (JSON)

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:Describe*",
        "ec2:StartInstances",
        "ec2:StopInstances",
        "ec2:RebootInstances",
        "s3:GetObject",
        "s3:PutObject",
        "s3:ListBucket",
        "lambda:InvokeFunction",
        "lambda:GetFunction",
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Deny",
      "Action": [
        "ec2:TerminateInstances",
        "s3:DeleteBucket",
        "iam:*"
      ],
      "Resource": "*"
    }
  ]
}
```

### Data Analyst Policy (JSON)

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:ListBucket"
      ],
      "Resource": [
        "arn:aws:s3:::data-lake-bucket",
        "arn:aws:s3:::data-lake-bucket/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "athena:*",
        "glue:GetDatabase",
        "glue:GetTable",
        "glue:GetTables",
        "glue:GetPartitions"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "quicksight:*"
      ],
      "Resource": "*"
    }
  ]
}
```

## Best Practices

1. **Use Groups for Permission Management** - Assign permissions to groups, not individual users
2. **Enable MFA** - Require multi-factor authentication for all human users
3. **Principle of Least Privilege** - Grant only the minimum permissions required
4. **Regular Access Reviews** - Periodically review and audit user permissions
5. **Use Service Accounts** - Create dedicated users for applications and services
6. **Secure Credential Management** - Use encrypted passwords and access keys
7. **Implement Proper Tagging** - Tag users for cost allocation and management
8. **Monitor User Activity** - Use CloudTrail to track user actions
9. **Rotate Access Keys** - Regularly rotate programmatic access keys
10. **Use Temporary Credentials** - Prefer IAM roles over long-term access keys when possible

## Security Considerations

- All passwords are encrypted with PGP keys
- Access keys are encrypted and should be stored securely
- MFA devices provide additional security layer
- Custom policies should follow least privilege principle
- Regular audit of user permissions and access patterns
- Monitor for unused users and access keys
- Implement strong password policies
- Use CloudTrail for activity monitoring

## Cost Optimization

- Remove unused IAM users and access keys
- Use groups to reduce policy management overhead
- Monitor IAM usage with AWS Cost Explorer
- Implement automated cleanup of inactive users
- Use service-linked roles where possible instead of users

## Monitoring and Compliance

- Enable CloudTrail for IAM API logging
- Set up CloudWatch alarms for suspicious activities
- Use AWS Config for compliance monitoring
- Implement access reviews and certification processes
- Monitor failed login attempts and access key usage

## Troubleshooting

### Common Issues

1. **Password decryption failures** - Check PGP key configuration
2. **Policy attachment errors** - Verify policy syntax and permissions
3. **MFA setup issues** - Ensure virtual MFA device is properly configured
4. **Group membership problems** - Check group existence and permissions

### Debugging Commands

```bash
# List IAM users
aws iam list-users

# Get user details
aws iam get-user --user-name username

# List user's groups
aws iam get-groups-for-user --user-name username

# List user's attached policies
aws iam list-attached-user-policies --user-name username

# Get user's access keys
aws iam list-access-keys --user-name username

# Check MFA devices
aws iam list-mfa-devices --user-name username

# Decrypt password (requires PGP private key)
echo "encrypted_password" | base64 -d | gpg --decrypt
```

## Password Management

### Decrypting User Passwords

```bash
# The module outputs encrypted passwords that need to be decrypted
# Save the PGP private key to a file
echo "${module.iam_user.pgp_private_key}" > private_key.asc

# Import the private key
gpg --import private_key.asc

# Decrypt the password
echo "${module.iam_user.password_credentials}" | base64 -d | gpg --decrypt

# Clean up
rm private_key.asc
```

### Setting Up MFA

1. **Get the QR Code**: Use the `mfa_device_qr_code` output
2. **Scan with Authenticator App**: Google Authenticator, Authy, etc.
3. **Complete Setup**: Enter the 6-digit code to verify
4. **Test Login**: Ensure MFA is working properly

## License

This module is released under the MIT License. See LICENSE file for details.