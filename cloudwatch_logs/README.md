# Cloudwatch Logs
Amazon CloudWatch Logs is a monitoring service offered by AWS for collecting, monitoring, and analyzing your system, application, and custom log files. This service provides a simple way to efficiently manage logs from multiple sources and allows you to visualize, understand, and query the data contained within those logs.

## Key Features

### 1. Log Collection & Storage:
You can easily send logs to CloudWatch from Amazon EC2 instances, AWS CloudTrail, or other sources.
### 2. Real-Time Monitoring: 
Stream logs in real-time and monitor them through specific metrics.
### 3. Scalable Architecture: 
It automatically scales with your log volume and velocity without any operational overhead.
### 4. Search & Filtering: 
Advanced search features help you filter log data based on criteria that you define.
### 5. Alerts: 
Set up alarms to notify you of specific events or patterns in logs.
### 6. Integration with Other Services: 
Works seamlessly with services like AWS Lambda, S3, Elasticsearch, etc.

## How to Use CloudWatch Logs

### 1.Set Up Log Collection: 
Configure your AWS services and applications to send logs to CloudWatch.
### 2. View & Search Logs: 
Access your logs in the CloudWatch console to view and search through them.
### 3. Monitor & Alarm: 
Create customized metrics and set up alarms to be notified of particular log events.
### 4. Archive & Retention Policies: 
Define retention policies to store logs for the desired duration and archive older logs to Amazon S3 for long-term storage.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.60.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.cloudwatch_logs_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_kms_alias.alias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.cloudwatch_kms_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_kms_key_policy.cloudwatch_kms_key_ploicy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key_policy) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloudwatch_log_group_name"></a> [cloudwatch\_log\_group\_name](#input\_cloudwatch\_log\_group\_name) | cloudwatch log goup nme | `string` | `null` | no |
| <a name="input_log_group_class"></a> [log\_group\_class](#input\_log\_group\_class) | Specified the log class of the log group. Possible values are: STANDARD or INFREQUENT\_ACCESS. | `string` | `"STANDARD"` | no |
| <a name="input_log_group_skip_destroy"></a> [log\_group\_skip\_destroy](#input\_log\_group\_skip\_destroy) | Set to true if you do not wish the log group (and any logs it may contain) to be deleted at destroy time, and instead just remove the log group from the Terraform state. | `bool` | `false` | no |
| <a name="input_logs_retention_in_days"></a> [logs\_retention\_in\_days](#input\_logs\_retention\_in\_days) | Specifies the number of days you want to retain log events in the specified log group. | `number` | `7` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloudwatch_logs_arn"></a> [cloudwatch\_logs\_arn](#output\_cloudwatch\_logs\_arn) | cloudwatch log group arn |
