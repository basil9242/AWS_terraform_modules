## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.56.0 or lastest |

## Resources

| Name | Type |
|------|------|
| [aws_iam_group.iam_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group) | resource |
| [aws_iam_group_membership.iam_group_member](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group_membership) | resource |
| [aws_iam_group_policy_attachment.iam_policy_attach_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group_policy_attachment) | resource |
| [aws_iam_policy.iam_policy-group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_user.iam_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |
| [aws_iam_user_login_profile.iam_user_login](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_login_profile) | resource |
| [aws_iam_user_policy.iam_user_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_iam_group_name"></a> [iam\_group\_name](#input\_iam\_group\_name) | IAM group name | `string` | `""` | no |
| <a name="input_iam_group_path"></a> [iam\_group\_path](#input\_iam\_group\_path) | IAM user path ,default value is '/'(example:'/system/') | `string` | `"/"` | no |
| <a name="input_iam_group_policy_json_file_path"></a> [iam\_group\_policy\_json\_file\_path](#input\_iam\_group\_policy\_json\_file\_path) | JSON file path if iam policy json file is true | `file` | `null` | no |
| <a name="input_iam_group_yes_no"></a> [iam\_group\_yes\_no](#input\_iam\_group\_yes\_no) | IAM group requried or not | `bool` | `false` | no |
| <a name="input_iam_policy_json_file"></a> [iam\_policy\_json\_file](#input\_iam\_policy\_json\_file) | IAM policy arn or json file, if json file true else false | `bool` | `false` | no |
| <a name="input_iam_user_name"></a> [iam\_user\_name](#input\_iam\_user\_name) | IAM user name | `string` | `""` | no |
| <a name="input_iam_user_path"></a> [iam\_user\_path](#input\_iam\_user\_path) | IAM user path ,default value is '/'(example:'/system/') | `string` | `"/"` | no |
| <a name="input_iam_user_policy_json_file_path"></a> [iam\_user\_policy\_json\_file\_path](#input\_iam\_user\_policy\_json\_file\_path) | iam user policy json file | `file` | `null` | no |
| <a name="input_iam_user_tags"></a> [iam\_user\_tags](#input\_iam\_user\_tags) | IAM user tags (example:Environment = 'Production' Department  = 'IT') | `map(string)` | `null` | no |
| <a name="input_policy_arn"></a> [policy\_arn](#input\_policy\_arn) | IAM policy arn for IAM group | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_password"></a> [password](#output\_password) | n/a |