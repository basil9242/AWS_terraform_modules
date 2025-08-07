# S3 Bucket Public Read Prohibited Module

This Terraform module creates an AWS Config rule that monitors and ensures S3 buckets are not publicly readable. It helps maintain security compliance by automatically detecting S3 buckets that allow public read access and flagging them as non-compliant.

## Overview

The module implements the AWS Config managed rule `S3_BUCKET_PUBLIC_READ_PROHIBITED` which evaluates whether your Amazon S3 buckets allow public read access. This is crucial for maintaining data security and preventing accidental exposure of sensitive information.

## Features

- **AWS Config Rule**: Implements the managed rule `S3_BUCKET_PUBLIC_READ_PROHIBITED`
- **Configuration Recorder**: Sets up AWS Config recorder to monitor S3 bucket configurations
- **IAM Role**: Creates necessary IAM role and policies for AWS Config service
- **Compliance Monitoring**: Continuously monitors S3 buckets for public read access
- **Security Compliance**: Helps meet security compliance requirements
- **Automated Detection**: Automatically detects non-compliant S3 buckets
- **SNS Notifications**: Optional SNS topic creation for real-time compliance alerts
- **CloudWatch Events**: Integration with CloudWatch Events for automated notifications
- **Flexible Alerting**: Support for both new and existing SNS topics

## Architecture

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   S3 Buckets    │───▶│   AWS Config     │───▶│  Config Rule    │
│                 │    │   Recorder       │    │  (S3 Public     │
│ - Bucket A      │    │                  │    │   Read Check)   │
│ - Bucket B      │    │                  │    │                 │
│ - Bucket C      │    │                  │    │                 │
└─────────────────┘    └──────────────────┘    └─────────────────┘
                                │
                                ▼
                       ┌─────────────────┐
                       │  Compliance     │
                       │  Dashboard      │
                       │                 │
                       │ ✓ Compliant     │
                       │ ✗ Non-compliant │
                       └─────────────────┘
```

## Usage

### Basic Usage

```hcl
module "s3_public_read_prohibited" {
  source = "./s3-bucket-public-read-prohibited"
  
  config_rule_name          = "s3-bucket-public-read-prohibited"
  config_rule_recorder_name = "s3-bucket-recorder"
}
```

### Complete Setup with Delivery Channel and SNS Notifications

```hcl
module "s3_public_read_prohibited" {
  source = "./s3-bucket-public-read-prohibited"
  
  config_rule_name          = "s3-bucket-public-read-prohibited"
  config_rule_recorder_name = "s3-bucket-recorder"
  
  # Specify bucket name to automatically create delivery channel
  config_s3_bucket_name = "my-aws-config-bucket"
  config_s3_key_prefix  = "config"
  delivery_channel_name = "s3-config-delivery-channel"
  
  # SNS Notifications for compliance changes
  create_sns_topic                = true
  sns_topic_name                  = "s3-compliance-alerts"
  enable_compliance_notifications = true
  
  tags = {
    Environment = "production"
    Purpose     = "compliance"
    Owner       = "security-team"
  }
}
```

### Using Existing SNS Topic

```hcl
module "s3_public_read_prohibited" {
  source = "./s3-bucket-public-read-prohibited"
  
  config_rule_name          = "s3-bucket-public-read-prohibited"
  config_rule_recorder_name = "s3-bucket-recorder"
  
  # Use existing SNS topic
  sns_topic_arn                   = "arn:aws:sns:us-west-2:123456789012:existing-topic"
  enable_compliance_notifications = true
  
  tags = {
    Environment = "production"
    Purpose     = "compliance"
  }
}
```

### Advanced Usage with Custom Names

```hcl
module "s3_public_read_prohibited" {
  source = "./s3-bucket-public-read-prohibited"
  
  config_rule_name          = "my-org-s3-public-read-check"
  config_rule_recorder_name = "my-org-s3-config-recorder"
  
  # Minimal setup (assumes delivery channel exists)
  create_delivery_channel = false
  
  tags = {
    Organization = "my-org"
    Team         = "security"
  }
}
```

### Integration with Other Modules

```hcl
# Create S3 bucket with proper security
module "secure_s3_bucket" {
  source = "./s3"
  
  bucket_name                = "my-secure-bucket"
  block_public_acls          = true
  block_public_policy        = true
  ignore_public_acls         = true
  restrict_public_buckets    = true
  
  tags = {
    Environment = "production"
    Compliance  = "required"
  }
}

# Monitor S3 buckets for public read access
module "s3_public_read_prohibited" {
  source = "./s3-bucket-public-read-prohibited"
  
  config_rule_name          = "s3-bucket-public-read-prohibited"
  config_rule_recorder_name = "s3-bucket-recorder"
  
  depends_on = [module.secure_s3_bucket]
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| aws | >= 4.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 4.0 |

## Resources Created

| Resource | Type | Description |
|----------|------|-------------|
| `aws_config_config_rule.prohibhite_s3_bucket_public_access` | Config Rule | AWS Config rule to check S3 bucket public read access |
| `aws_config_configuration_recorder.prohibhite_s3_bucket_public_access` | Configuration Recorder | Records configuration changes for AWS resources |
| `aws_iam_role.s3_awsconfig_role` | IAM Role | Service role for AWS Config |
| `aws_iam_role_policy.s3-awsconfig-policy` | IAM Policy | Policy allowing Config service to function |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `config_rule_name` | Name of the AWS Config rule | `string` | `"s3-bucket-public-read-prohibited"` | no |
| `config_rule_recorder_name` | Name of the AWS Config rule recorder | `string` | `"s3-bucket-recorder"` | no |
| `delivery_channel_name` | Name of the delivery channel (only used if config_s3_bucket_name is provided) | `string` | `"s3-config-delivery-channel"` | no |
| `config_s3_bucket_name` | S3 bucket name for AWS Config delivery channel. If provided, a delivery channel will be created automatically. | `string` | `""` | no |
| `config_s3_key_prefix` | S3 key prefix for AWS Config delivery channel | `string` | `"config"` | no |
| `create_sns_topic` | Whether to create an SNS topic for Config notifications | `bool` | `false` | no |
| `sns_topic_name` | Name of the SNS topic for Config notifications (only used if create_sns_topic is true) | `string` | `"aws-config-s3-compliance-notifications"` | no |
| `sns_topic_arn` | ARN of existing SNS topic for Config notifications. If provided, this topic will be used instead of creating a new one. | `string` | `""` | no |
| `enable_compliance_notifications` | Whether to enable CloudWatch Events for compliance change notifications | `bool` | `false` | no |
| `tags` | A map of tags to assign to the resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| `config_rule_name` | Name of the AWS Config rule |
| `config_rule_arn` | ARN of the AWS Config rule |
| `configuration_recorder_name` | Name of the AWS Config configuration recorder |
| `delivery_channel_name` | Name of the AWS Config delivery channel (if created) |
| `delivery_channel_created` | Whether a delivery channel was created |
| `sns_topic_arn` | ARN of the SNS topic for Config notifications (if created or provided) |
| `sns_topic_name` | Name of the SNS topic for Config notifications (if created) |
| `cloudwatch_event_rule_arn` | ARN of the CloudWatch Event Rule for compliance notifications (if enabled) |
| `iam_role_arn` | ARN of the IAM role created for AWS Config |
| `iam_role_name` | Name of the IAM role created for AWS Config |
| `recorder_status` | Status of the configuration recorder |

## What the Rule Checks

The `S3_BUCKET_PUBLIC_READ_PROHIBITED` rule evaluates whether your S3 buckets allow public read access through:

1. **Bucket ACLs**: Checks if bucket ACLs grant read access to "AllUsers" or "AuthenticatedUsers"
2. **Bucket Policies**: Evaluates bucket policies for statements that allow public read access
3. **Public Access Block**: Considers the bucket's Public Access Block settings

### Compliance Conditions

A bucket is **COMPLIANT** when:
- No bucket ACL grants read access to "AllUsers" or "AuthenticatedUsers"
- No bucket policy allows public read access
- Public Access Block settings prevent public read access

A bucket is **NON_COMPLIANT** when:
- Bucket ACL grants read access to "AllUsers" or "AuthenticatedUsers"
- Bucket policy contains statements allowing public read access
- Public Access Block settings don't prevent public read access

## Prerequisites

### 1. AWS Config Service

Ensure AWS Config is enabled in your AWS account and region:

```bash
# Check if AWS Config is enabled
aws configservice describe-configuration-recorders
aws configservice describe-delivery-channels
```

### 1.1. S3 Bucket for Config Delivery Channel

If you don't have an existing delivery channel, create an S3 bucket:

```bash
# Create S3 bucket for AWS Config
aws s3 mb s3://my-aws-config-bucket --region us-west-2

# Apply bucket policy for AWS Config
aws s3api put-bucket-policy --bucket my-aws-config-bucket --policy '{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AWSConfigBucketPermissionsCheck",
      "Effect": "Allow",
      "Principal": {
        "Service": "config.amazonaws.com"
      },
      "Action": "s3:GetBucketAcl",
      "Resource": "arn:aws:s3:::my-aws-config-bucket"
    },
    {
      "Sid": "AWSConfigBucketExistenceCheck",
      "Effect": "Allow",
      "Principal": {
        "Service": "config.amazonaws.com"
      },
      "Action": "s3:ListBucket",
      "Resource": "arn:aws:s3:::my-aws-config-bucket"
    },
    {
      "Sid": "AWSConfigBucketDelivery",
      "Effect": "Allow",
      "Principal": {
        "Service": "config.amazonaws.com"
      },
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::my-aws-config-bucket/*",
      "Condition": {
        "StringEquals": {
          "s3:x-amz-acl": "bucket-owner-full-control"
        }
      }
    }
  ]
}'
```

### 2. IAM Permissions

Your AWS credentials need permissions for:
- `config:*`
- `iam:CreateRole`
- `iam:CreatePolicy`
- `iam:AttachRolePolicy`
- `iam:PassRole`
- `s3:GetBucketAcl`
- `s3:GetBucketPolicy`
- `s3:GetBucketPolicyStatus`
- `s3:GetBucketPublicAccessBlock`
- `s3:ListBucket`
- `s3:PutObject` (for delivery channel)
- `s3:GetObject` (for delivery channel)

### 3. S3 Service-Linked Role

AWS Config requires a service-linked role for S3:

```bash
# Create service-linked role if it doesn't exist
aws iam create-service-linked-role --aws-service-name config.amazonaws.com
```

## Monitoring and Compliance

### Viewing Compliance Status

```bash
# Check compliance status of the rule
aws configservice get-compliance-details-by-config-rule \
  --config-rule-name s3-bucket-public-read-prohibited

# Get compliance summary
aws configservice get-compliance-summary-by-config-rule \
  --config-rule-names s3-bucket-public-read-prohibited
```

### SNS Notifications

When enabled, the module sends detailed notifications to SNS when S3 buckets become non-compliant:

```json
{
  "alert_type": "AWS Config Compliance Alert",
  "rule_name": "s3-bucket-public-read-prohibited",
  "compliance_status": "NON_COMPLIANT",
  "resource_type": "AWS::S3::Bucket",
  "resource_id": "my-public-bucket",
  "aws_region": "us-west-2",
  "aws_account_id": "123456789012",
  "message": "S3 Bucket 'my-public-bucket' is now NON_COMPLIANT for rule 's3-bucket-public-read-prohibited'",
  "timestamp": "2024-01-15T10:30:00Z"
}
```

### CloudWatch Integration

AWS Config automatically publishes compliance metrics to CloudWatch:

```hcl
# Example CloudWatch alarm for non-compliant resources
resource "aws_cloudwatch_metric_alarm" "s3_compliance_alarm" {
  alarm_name          = "s3-bucket-public-read-non-compliant"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "ComplianceByConfigRule"
  namespace           = "AWS/Config"
  period              = "300"
  statistic           = "Maximum"
  threshold           = "0"
  alarm_description   = "This metric monitors S3 bucket public read compliance"
  
  dimensions = {
    ConfigRuleName = var.config_rule_name
    ComplianceType = "NON_COMPLIANT"
  }
}
```

## Remediation

When the rule detects non-compliant S3 buckets, you can:

### 1. Manual Remediation

```bash
# Remove public read access from bucket ACL
aws s3api put-bucket-acl --bucket my-bucket --acl private

# Enable Public Access Block
aws s3api put-public-access-block --bucket my-bucket \
  --public-access-block-configuration \
  BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true
```

### 2. Automated Remediation

```hcl
# Example Lambda function for automated remediation
resource "aws_lambda_function" "s3_remediation" {
  filename         = "s3_remediation.zip"
  function_name    = "s3-public-read-remediation"
  role            = aws_iam_role.lambda_role.arn
  handler         = "index.handler"
  runtime         = "python3.9"
  
  # Lambda function code would remove public read access
}

# CloudWatch Event Rule to trigger remediation
resource "aws_cloudwatch_event_rule" "config_rule_compliance" {
  name = "s3-config-compliance-change"
  
  event_pattern = jsonencode({
    source      = ["aws.config"]
    detail-type = ["Config Rules Compliance Change"]
    detail = {
      configRuleName = [var.config_rule_name]
      newEvaluationResult = {
        complianceType = ["NON_COMPLIANT"]
      }
    }
  })
}
```

## Cost Considerations

### AWS Config Pricing

- **Configuration Items**: Charged per configuration item recorded
- **Rule Evaluations**: Charged per rule evaluation
- **Conformance Packs**: Additional charges if using conformance packs

### Cost Optimization Tips

1. **Targeted Monitoring**: Use resource-based recording to monitor only S3 buckets
2. **Evaluation Frequency**: Consider the trade-off between compliance monitoring frequency and cost
3. **Regional Deployment**: Deploy only in regions where you have S3 buckets

## Security Best Practices

### 1. Least Privilege IAM

The module creates minimal IAM permissions required for AWS Config:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["config:Put*"],
      "Resource": "*"
    }
  ]
}
```

### 2. Regular Compliance Reviews

- Set up CloudWatch alarms for non-compliant resources
- Implement automated remediation where possible
- Regular manual reviews of compliance status

### 3. Integration with Security Tools

- Integrate with AWS Security Hub
- Use with AWS Systems Manager for automated remediation
- Include in security incident response procedures

## Troubleshooting

### Common Issues

1. **Config Rule Not Evaluating**
   ```bash
   # Check if Configuration Recorder is active
   aws configservice describe-configuration-recorder-status
   
   # Start Configuration Recorder if stopped
   aws configservice start-configuration-recorder --configuration-recorder-name default
   ```

2. **IAM Permission Issues**
   ```bash
   # Verify IAM role has correct permissions
   aws iam get-role-policy --role-name s3-awsconfig-role --policy-name my-awsconfig-policy
   ```

3. **No Compliance Results**
   ```bash
   # Trigger manual evaluation
   aws configservice start-config-rules-evaluation --config-rule-names s3-bucket-public-read-prohibited
   ```

## Examples

### Complete Security Compliance Setup

```hcl
# Enable AWS Config
resource "aws_config_delivery_channel" "main" {
  name           = "main"
  s3_bucket_name = aws_s3_bucket.config.bucket
}

# S3 bucket for Config
resource "aws_s3_bucket" "config" {
  bucket        = "my-aws-config-bucket"
  force_destroy = true
}

# S3 Public Read Prohibited Rule
module "s3_public_read_prohibited" {
  source = "./s3-bucket-public-read-prohibited"
  
  config_rule_name          = "s3-bucket-public-read-prohibited"
  config_rule_recorder_name = "main-recorder"
}

# Additional Config rules for comprehensive S3 security
module "s3_public_write_prohibited" {
  source = "./s3-bucket-public-write-prohibited"  # If available
  
  config_rule_name          = "s3-bucket-public-write-prohibited"
  config_rule_recorder_name = "main-recorder"
}
```

## Contributing

1. Follow Terraform best practices
2. Add appropriate variable validation
3. Include comprehensive documentation
4. Test with different AWS Config setups
5. Ensure IAM permissions follow least privilege principle
