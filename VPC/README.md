## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.0.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.vpc_cloudwatch_logs_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_flow_log.vpc_flow_log](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/flow_log) | resource |
| [aws_iam_role.vpc_logs_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.vpc_logs_iam_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_kms_key.vpc_kms_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_kms_key_policy.vpc_kms_key_ploicy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key_policy) | resource |
| [aws_route_table.route_table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_subnet.vpc_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.vpc_logs_assume_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.vpc_logs_assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_zone"></a> [availability\_zone](#input\_availability\_zone) | availability zone for subnet | `list(string)` | `[]` | no |
| <a name="input_cidr_block_subnet"></a> [cidr\_block\_subnet](#input\_cidr\_block\_subnet) | Subnet for cidr block | `list(string)` | `[]` | no |
| <a name="input_cidr_block_vpc"></a> [cidr\_block\_vpc](#input\_cidr\_block\_vpc) | CIDR block for VPC | `string` | `""` | no |
| <a name="input_enable_dns_hostnames"></a> [enable\_dns\_hostnames](#input\_enable\_dns\_hostnames) | A boolean flag to enable/disable DNS hostnames in the VPC | `bool` | `false` | no |
| <a name="input_route_table_name"></a> [route\_table\_name](#input\_route\_table\_name) | Route table name | `string` | `""` | no |
| <a name="input_subnet_name"></a> [subnet\_name](#input\_subnet\_name) | Subnet names | `list(string)` | `[]` | no |
| <a name="input_vpc_cloudwatch_logs_group_name"></a> [vpc\_cloudwatch\_logs\_group\_name](#input\_vpc\_cloudwatch\_logs\_group\_name) | vpc flow logs cloudwatch group name | `string` | `""` | no |
| <a name="input_vpc_instance_tenancy"></a> [vpc\_instance\_tenancy](#input\_vpc\_instance\_tenancy) | A tenancy option for instances launched into the VPCu | `string` | `"default"` | no |
| <a name="input_vpc_logs_policy_name"></a> [vpc\_logs\_policy\_name](#input\_vpc\_logs\_policy\_name) | VPC flo logs policy | `string` | `""` | no |
| <a name="input_vpc_logs_role_name"></a> [vpc\_logs\_role\_name](#input\_vpc\_logs\_role\_name) | VPC flow logs IAM role | `string` | `""` | no |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | VPC name | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | n/a |