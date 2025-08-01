# AWS CloudWatch Logs Terraform Module

A comprehensive Terraform module for creating and managing AWS CloudWatch Logs resources with advanced features including KMS encryption, log streams, metric filters, and cross-account log destinations.

## Features

- ✅ **CloudWatch Log Groups** with configurable retention and encryption
- ✅ **KMS Encryption** with automatic key rotation and least-privilege policies
- ✅ **Log Streams** for organized log data
- ✅ **Metric Filters** for monitoring and alerting
- ✅ **Log Subscription Filters** for real-time log processing
- ✅ **Cross-Account Log Destinations** for centralized logging
- ✅ **Comprehensive Tagging** support
- ✅ **Variable Validation** for input safety

## Usage

### Basic Usage

```hcl
module "cloudwatch_logs" {
  source = "git::https://github.com/basil9242/AWS_terraform_modules.git//cloudwatch_logs"
  
  cloudwatch_log_group_name = "my-application-logs"
  logs_retention_in_days    = 30
  
  tags = {
    Environment = "production"
    Application = "my-app"
  }
}
```

### Advanced Usage with All Features

```hcl
module "cloudwatch_logs" {
  source = "git::https://github.com/basil9242/AWS_terraform_modules.git//cloudwatch_logs"
  
  # Basic Configuration
  cloudwatch_log_group_name = "my-application-logs"
  logs_retention_in_days    = 90
  log_group_class          = "STANDARD"
  
  # KMS Configuration
  enable_kms_key_rotation  = true
  kms_key_deletion_window  = 30
  
  # Log Streams
  create_log_streams = true
  log_streams = [
    "application-stream",
    "error-stream",
    "access-stream"
  ]
  
  # Metric Filters
  create_metric_filters = true
  metric_filters = [
    {
      name             = "error-count"
      pattern          = "[timestamp, request_id, level=\"ERROR\", ...]"
      metric_name      = "ApplicationErrors"
      metric_namespace = "MyApp/Logs"
      metric_value     = "1"
      default_value    = 0
    }
  ]
  
  # Subscription Filter
  cloudwatch_log_subscription_filter_required = true
  cloudwatch_log_filter                       = "[timestamp, request_id, level, message]"
  destination_arn_push_logs                   = "arn:aws:lambda:us-east-1:123456789012:function:log-processor"
  
  # Cross-Account Log Destination
  create_log_destination      = true
  log_destination_name        = "central-logging-destination"
  log_destination_role_arn    = "arn:aws:iam::123456789012:role/LogDestinationRole"
  log_destination_target_arn  = "arn:aws:kinesis:us-east-1:123456789012:stream/central-logs"
  
  # Tagging
  environment  = "production"
  project_name = "my-project"
  tags = {
    Owner       = "platform-team"
    CostCenter  = "engineering"
    Compliance  = "required"
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
| `aws_cloudwatch_log_group` | Main log group with encryption and retention |
| `aws_kms_key` | KMS key for log encryption |
| `aws_kms_key_policy` | Least-privilege KMS key policy |
| `aws_kms_alias` | Human-readable alias for the KMS key |
| `aws_cloudwatch_log_stream` | Individual log streams (optional) |
| `aws_cloudwatch_log_metric_filter` | Metric filters for monitoring (optional) |
| `aws_cloudwatch_log_subscription_filter` | Real-time log processing (optional) |
| `aws_cloudwatch_log_destination` | Cross-account log destination (optional) |
| `aws_iam_role` | IAM role for subscription filter (when needed) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `cloudwatch_log_group_name` | CloudWatch log group name | `string` | n/a | yes |
| `logs_retention_in_days` | Log retention period in days | `number` | `7` | no |
| `log_group_class` | Log class (STANDARD or INFREQUENT_ACCESS) | `string` | `"STANDARD"` | no |
| `log_group_skip_destroy` | Skip log group deletion on destroy | `bool` | `false` | no |
| `enable_kms_key_rotation` | Enable automatic KMS key rotation | `bool` | `true` | no |
| `kms_key_deletion_window` | KMS key deletion window (7-30 days) | `number` | `20` | no |
| `create_log_streams` | Create log streams | `bool` | `false` | no |
| `log_streams` | List of log stream names | `list(string)` | `[]` | no |
| `create_metric_filters` | Create metric filters | `bool` | `false` | no |
| `metric_filters` | List of metric filter configurations | `list(object)` | `[]` | no |
| `cloudwatch_log_subscription_filter_required` | Enable subscription filter | `bool` | `false` | no |
| `cloudwatch_log_filter` | Log filter pattern | `string` | `null` | no |
| `destination_arn_push_logs` | Destination ARN for log events | `string` | `null` | no |
| `create_log_destination` | Create cross-account log destination | `bool` | `false` | no |
| `tags` | Resource tags | `map(string)` | `{}` | no |
| `environment` | Environment name | `string` | `"dev"` | no |
| `project_name` | Project name | `string` | `"default"` | no |

## Outputs

| Name | Description |
|------|-------------|
| `cloudwatch_logs_arn` | CloudWatch log group ARN |
| `cloudwatch_logs_name` | CloudWatch log group name |
| `kms_key_id` | KMS key ID |
| `kms_key_arn` | KMS key ARN |
| `kms_alias_name` | KMS key alias name |
| `log_streams` | Created log stream names |
| `metric_filters` | Created metric filter names |
| `log_destination_arn` | Log destination ARN (if created) |

## Examples

### Error Monitoring Setup

```hcl
module "error_monitoring_logs" {
  source = "git::https://github.com/basil9242/AWS_terraform_modules.git//cloudwatch_logs"
  
  cloudwatch_log_group_name = "application-errors"
  logs_retention_in_days    = 365
  
  create_metric_filters = true
  metric_filters = [
    {
      name             = "critical-errors"
      pattern          = "[timestamp, request_id, level=\"CRITICAL\", ...]"
      metric_name      = "CriticalErrors"
      metric_namespace = "Application/Errors"
    },
    {
      name             = "error-rate"
      pattern          = "[timestamp, request_id, level=\"ERROR\", ...]"
      metric_name      = "ErrorRate"
      metric_namespace = "Application/Metrics"
    }
  ]
  
  tags = {
    Purpose = "error-monitoring"
    Team    = "sre"
  }
}
```

### Centralized Logging

```hcl
module "centralized_logs" {
  source = "git::https://github.com/basil9242/AWS_terraform_modules.git//cloudwatch_logs"
  
  cloudwatch_log_group_name = "central-application-logs"
  
  create_log_destination     = true
  log_destination_name       = "central-log-destination"
  log_destination_role_arn   = aws_iam_role.log_destination_role.arn
  log_destination_target_arn = aws_kinesis_stream.central_logs.arn
  
  tags = {
    LoggingStrategy = "centralized"
    DataRetention   = "long-term"
  }
}
```

## Best Practices

1. **Use appropriate retention periods** - Balance cost and compliance requirements
2. **Enable KMS encryption** - Protect sensitive log data
3. **Implement metric filters** - Monitor application health and errors
4. **Use consistent tagging** - Enable proper cost allocation and resource management
5. **Set up subscription filters** - Enable real-time log processing and alerting
6. **Consider log classes** - Use INFREQUENT_ACCESS for cost optimization on rarely accessed logs

## Security Considerations

- KMS keys use least-privilege policies
- Log groups are encrypted by default
- Cross-account access is properly controlled
- IAM roles follow principle of least privilege

## Cost Optimization

- Use appropriate retention periods
- Consider INFREQUENT_ACCESS log class for archival logs
- Implement lifecycle policies for long-term storage
- Monitor CloudWatch Logs costs with proper tagging

