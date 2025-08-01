# AWS S3 Bucket Terraform Module

A comprehensive Terraform module for creating and managing AWS S3 buckets with advanced security features, lifecycle management, notifications, and compliance configurations.

## Features

- ✅ **Secure S3 Buckets** with KMS encryption and public access blocking
- ✅ **Lifecycle Management** with intelligent tiering and expiration policies
- ✅ **Versioning Support** with noncurrent version management
- ✅ **Access Logging** for audit and compliance
- ✅ **Event Notifications** (Lambda, SNS, SQS)
- ✅ **CORS Configuration** for web applications
- ✅ **Website Hosting** capabilities
- ✅ **Bucket Policies** with JSON file support
- ✅ **Comprehensive Tagging** support
- ✅ **Variable Validation** for input safety

## Usage

### Basic S3 Bucket

```hcl
module "s3_bucket" {
  source = "git::https://github.com/basil9242/AWS_terraform_modules.git//s3"
  
  bucket_name = "my-application-bucket"
  
  tags = {
    Environment = "production"
    Application = "my-app"
  }
}
```

### Advanced S3 Bucket with All Features

```hcl
module "s3_bucket" {
  source = "git::https://github.com/basil9242/AWS_terraform_modules.git//s3"
  
  # Basic Configuration
  bucket_name           = "my-advanced-bucket"
  bucket_object_destroy = false
  
  # ACL Configuration (deprecated, use bucket policies instead)
  enable_bucket_acl = false
  object_ownership  = "BucketOwnerEnforced"
  
  # Versioning
  s3_bucket_versioning = "Enabled"
  
  # Public Access Block (Security)
  s3_block_public_acls       = true
  s3_block_public_policy     = true
  s3_restrict_public_buckets = true
  s3_ignore_public_acls      = true
  
  # Lifecycle Configuration
  enable_lifecycle_configuration = true
  lifecycle_rules = [
    {
      id     = "transition-to-ia"
      status = "Enabled"
      transitions = [
        {
          days          = 30
          storage_class = "STANDARD_IA"
        },
        {
          days          = 90
          storage_class = "GLACIER"
        },
        {
          days          = 365
          storage_class = "DEEP_ARCHIVE"
        }
      ]
      noncurrent_version_transitions = [
        {
          days          = 30
          storage_class = "STANDARD_IA"
        }
      ]
      noncurrent_version_expiration = {
        days = 90
      }
    },
    {
      id     = "delete-incomplete-uploads"
      status = "Enabled"
      expiration = {
        days = 7
      }
      filter = {
        prefix = "uploads/"
      }
    }
  ]
  
  # Access Logging
  enable_logging         = true
  logging_target_bucket  = "my-access-logs-bucket"
  logging_target_prefix  = "access-logs/"
  
  # Event Notifications
  enable_notifications = true
  lambda_notifications = [
    {
      function_arn  = "arn:aws:lambda:us-east-1:123456789012:function:process-uploads"
      events        = ["s3:ObjectCreated:*"]
      filter_prefix = "uploads/"
      filter_suffix = ".jpg"
    }
  ]
  
  sns_notifications = [
    {
      topic_arn     = "arn:aws:sns:us-east-1:123456789012:s3-notifications"
      events        = ["s3:ObjectRemoved:*"]
      filter_prefix = "important/"
    }
  ]
  
  # CORS Configuration
  enable_cors = true
  cors_rules = [
    {
      allowed_headers = ["*"]
      allowed_methods = ["GET", "POST", "PUT"]
      allowed_origins = ["https://mywebsite.com", "https://www.mywebsite.com"]
      expose_headers  = ["ETag"]
      max_age_seconds = 3000
    }
  ]
  
  # Website Configuration
  s3_bucket_website_configuration_required = true
  s3_website_index_document               = "index.html"
  s3_website_error_document               = "error.html"
  
  # Bucket Policy
  s3_bucket_policy_required      = true
  s3_bucket_policy_json_file_path = "./bucket-policy.json"
  
  # Tagging
  environment = "production"
  tags = {
    Owner       = "platform-team"
    CostCenter  = "engineering"
    Compliance  = "required"
    DataClass   = "confidential"
  }
}
```

### Static Website Hosting

```hcl
module "website_bucket" {
  source = "git::https://github.com/basil9242/AWS_terraform_modules.git//s3"
  
  bucket_name = "my-static-website"
  
  # Website Configuration
  s3_bucket_website_configuration_required = true
  s3_website_index_document               = "index.html"
  s3_website_error_document               = "404.html"
  
  # Public Access for Website
  s3_block_public_acls       = false
  s3_block_public_policy     = false
  s3_restrict_public_buckets = false
  s3_ignore_public_acls      = false
  
  # CORS for Web Assets
  enable_cors = true
  cors_rules = [
    {
      allowed_methods = ["GET"]
      allowed_origins = ["*"]
      max_age_seconds = 86400
    }
  ]
  
  tags = {
    Purpose = "static-website"
    Public  = "true"
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
| `aws_s3_bucket` | Main S3 bucket |
| `aws_s3_bucket_server_side_encryption_configuration` | KMS encryption configuration |
| `aws_s3_bucket_versioning` | Bucket versioning configuration |
| `aws_s3_bucket_public_access_block` | Public access block settings |
| `aws_s3_bucket_acl` | Bucket ACL (optional, deprecated) |
| `aws_s3_bucket_ownership_controls` | Object ownership controls |
| `aws_s3_bucket_lifecycle_configuration` | Lifecycle rules (optional) |
| `aws_s3_bucket_logging` | Access logging (optional) |
| `aws_s3_bucket_notification` | Event notifications (optional) |
| `aws_s3_bucket_cors_configuration` | CORS rules (optional) |
| `aws_s3_bucket_website_configuration` | Website hosting (optional) |
| `aws_s3_bucket_policy` | Bucket policy (optional) |
| `aws_kms_key` | KMS key for encryption |
| `aws_kms_key_policy` | KMS key policy |
| `aws_kms_alias` | KMS key alias |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `bucket_name` | Name of the S3 bucket | `string` | n/a | yes |
| `bucket_object_destroy` | Force destroy bucket with objects | `bool` | `false` | no |
| `s3_bucket_versioning` | Versioning status (Enabled/Disabled/Suspended) | `string` | `"Enabled"` | no |
| `enable_bucket_acl` | Enable bucket ACL (deprecated) | `bool` | `false` | no |
| `bucket_acl` | Bucket ACL type | `string` | `"private"` | no |
| `object_ownership` | Object ownership setting | `string` | `"BucketOwnerPreferred"` | no |
| `s3_block_public_acls` | Block public ACLs | `bool` | `true` | no |
| `s3_block_public_policy` | Block public bucket policies | `bool` | `true` | no |
| `s3_restrict_public_buckets` | Restrict public bucket policies | `bool` | `true` | no |
| `s3_ignore_public_acls` | Ignore public ACLs | `bool` | `true` | no |
| `enable_lifecycle_configuration` | Enable lifecycle configuration | `bool` | `false` | no |
| `lifecycle_rules` | List of lifecycle rules | `list(object)` | `[]` | no |
| `enable_logging` | Enable access logging | `bool` | `false` | no |
| `logging_target_bucket` | Target bucket for access logs | `string` | `null` | no |
| `logging_target_prefix` | Prefix for access log objects | `string` | `"access-logs/"` | no |
| `enable_notifications` | Enable bucket notifications | `bool` | `false` | no |
| `lambda_notifications` | Lambda function notifications | `list(object)` | `[]` | no |
| `sns_notifications` | SNS topic notifications | `list(object)` | `[]` | no |
| `sqs_notifications` | SQS queue notifications | `list(object)` | `[]` | no |
| `enable_cors` | Enable CORS configuration | `bool` | `false` | no |
| `cors_rules` | CORS rules | `list(object)` | `[]` | no |
| `s3_bucket_website_configuration_required` | Enable website configuration | `bool` | `false` | no |
| `s3_website_index_document` | Index document for website | `string` | `"index.html"` | no |
| `s3_website_error_document` | Error document for website | `string` | `"error.html"` | no |
| `s3_bucket_policy_required` | Apply bucket policy | `bool` | `false` | no |
| `s3_bucket_policy_json_file_path` | Path to bucket policy JSON file | `string` | `null` | no |
| `tags` | Resource tags | `map(string)` | `{}` | no |
| `environment` | Environment name | `string` | `"dev"` | no |

## Outputs

| Name | Description |
|------|-------------|
| `s3_bucket_id` | S3 bucket name |
| `s3_bucket_arn` | S3 bucket ARN |
| `s3_bucket_domain_name` | S3 bucket domain name |
| `s3_bucket_regional_domain_name` | S3 bucket regional domain name |
| `s3_bucket_hosted_zone_id` | S3 bucket hosted zone ID |
| `s3_bucket_region` | S3 bucket region |
| `s3_bucket_website_endpoint` | Website endpoint (if enabled) |
| `s3_bucket_kms_key_id` | KMS key ID |
| `s3_bucket_kms_arn` | KMS key ARN |

## Examples

### Data Lake Bucket

```hcl
module "data_lake_bucket" {
  source = "git::https://github.com/basil9242/AWS_terraform_modules.git//s3"
  
  bucket_name = "company-data-lake"
  
  # Intelligent Tiering for Cost Optimization
  enable_lifecycle_configuration = true
  lifecycle_rules = [
    {
      id     = "intelligent-tiering"
      status = "Enabled"
      transitions = [
        {
          days          = 0
          storage_class = "INTELLIGENT_TIERING"
        }
      ]
    },
    {
      id     = "archive-old-data"
      status = "Enabled"
      transitions = [
        {
          days          = 365
          storage_class = "GLACIER"
        },
        {
          days          = 2555  # 7 years
          storage_class = "DEEP_ARCHIVE"
        }
      ]
      filter = {
        prefix = "historical/"
      }
    }
  ]
  
  # Event Processing
  enable_notifications = true
  lambda_notifications = [
    {
      function_arn  = aws_lambda_function.data_processor.arn
      events        = ["s3:ObjectCreated:*"]
      filter_prefix = "raw-data/"
    }
  ]
  
  tags = {
    Purpose     = "data-lake"
    DataClass   = "analytics"
    Retention   = "7-years"
  }
}
```

### Backup Bucket

```hcl
module "backup_bucket" {
  source = "git::https://github.com/basil9242/AWS_terraform_modules.git//s3"
  
  bucket_name = "company-backups"
  
  # Versioning for Backup Protection
  s3_bucket_versioning = "Enabled"
  
  # Lifecycle for Cost Management
  enable_lifecycle_configuration = true
  lifecycle_rules = [
    {
      id     = "backup-lifecycle"
      status = "Enabled"
      transitions = [
        {
          days          = 30
          storage_class = "STANDARD_IA"
        },
        {
          days          = 90
          storage_class = "GLACIER"
        }
      ]
      noncurrent_version_transitions = [
        {
          days          = 30
          storage_class = "GLACIER"
        }
      ]
      noncurrent_version_expiration = {
        days = 365
      }
    }
  ]
  
  # Notifications for Backup Monitoring
  enable_notifications = true
  sns_notifications = [
    {
      topic_arn = aws_sns_topic.backup_alerts.arn
      events    = ["s3:ObjectCreated:*", "s3:ObjectRemoved:*"]
    }
  ]
  
  tags = {
    Purpose   = "backup"
    Critical  = "true"
    Retention = "1-year"
  }
}
```

## Best Practices

1. **Enable versioning** - Protect against accidental deletion and modification
2. **Use lifecycle policies** - Optimize costs with intelligent tiering
3. **Block public access** - Unless specifically needed for static websites
4. **Enable access logging** - For audit and compliance requirements
5. **Use KMS encryption** - Protect sensitive data at rest
6. **Implement proper tagging** - Enable cost allocation and resource management
7. **Set up notifications** - Monitor bucket activity and automate workflows
8. **Use bucket policies** - Control access with fine-grained permissions

## Security Considerations

- All buckets are encrypted with KMS by default
- Public access is blocked by default
- Bucket policies should follow least privilege principle
- Access logging helps with security monitoring
- Versioning provides protection against data loss
- MFA Delete can be enabled for additional protection

## Cost Optimization

- Use lifecycle policies to transition to cheaper storage classes
- Enable Intelligent Tiering for unpredictable access patterns
- Set up expiration policies for temporary data
- Monitor storage costs with proper tagging
- Consider S3 Storage Lens for optimization insights
- Use S3 Transfer Acceleration only when needed

## Compliance Features

- Server-side encryption with KMS
- Access logging for audit trails
- Versioning for data protection
- Lifecycle policies for retention management
- Object Lock for regulatory compliance (can be added)
- CloudTrail integration for API logging

## Troubleshooting

### Common Issues

1. **Access denied errors** - Check bucket policies and IAM permissions
2. **CORS errors** - Verify CORS configuration for web applications
3. **Lifecycle policy conflicts** - Ensure rules don't conflict with each other
4. **Notification failures** - Check destination permissions and configurations

### Debugging Commands

```bash
# Check bucket policy
aws s3api get-bucket-policy --bucket my-bucket

# List bucket notifications
aws s3api get-bucket-notification-configuration --bucket my-bucket

# Check lifecycle configuration
aws s3api get-bucket-lifecycle-configuration --bucket my-bucket

# Test CORS configuration
curl -H "Origin: https://example.com" \
     -H "Access-Control-Request-Method: GET" \
     -H "Access-Control-Request-Headers: X-Requested-With" \
     -X OPTIONS https://my-bucket.s3.amazonaws.com/
```

