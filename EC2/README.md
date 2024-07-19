## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | ~> 4.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.58.0 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | 4.0.5 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ebs_volume.ebs_volume_instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ebs_volume) | resource |
| [aws_iam_instance_profile.instance_profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_policy.iam_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.instance_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.attach_policy_arn_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.attach_policy_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_instance.instances](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_key_pair.kp](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) | resource |
| [aws_kms_key.ebs_kms](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_kms_key_policy.kms_poicy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key_policy) | resource |
| [aws_security_group.allow_tls](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_volume_attachment.ebs_attach_instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/volume_attachment) | resource |
| [aws_vpc_security_group_ingress_rule.allow_tls_ipv4](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule) | resource |
| [tls_private_key.pk](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_associate_public_ip_address"></a> [associate\_public\_ip\_address](#input\_associate\_public\_ip\_address) | Whether to associate a public IP address with an instance in a VPC | `bool` | `false` | no |
| <a name="input_attach_ebs_requried_or_not"></a> [attach\_ebs\_requried\_or\_not](#input\_attach\_ebs\_requried\_or\_not) | Attach EBS volume to EC2 instance other than root EBS volume requried | `bool` | `false` | no |
| <a name="input_attach_role_instance"></a> [attach\_role\_instance](#input\_attach\_role\_instance) | Attach iam role to instance, if requried true else false | `string` | `false` | no |
| <a name="input_availability_zone"></a> [availability\_zone](#input\_availability\_zone) | AZ to start the instance in | `string` | `null` | no |
| <a name="input_ebs_availability_zone"></a> [ebs\_availability\_zone](#input\_ebs\_availability\_zone) | The AZ where the EBS volume will exist. | `string` | `null` | no |
| <a name="input_ebs_device_name"></a> [ebs\_device\_name](#input\_ebs\_device\_name) | Name of the device to mount. | `string` | `null` | no |
| <a name="input_ebs_encryption"></a> [ebs\_encryption](#input\_ebs\_encryption) | Whether to enable volume encryption. Defaults to false | `bool` | `false` | no |
| <a name="input_ebs_final_snapshot"></a> [ebs\_final\_snapshot](#input\_ebs\_final\_snapshot) | If true, snapshot will be created before volume deletion. Any tags on the volume will be migrated to the snapshot. By default set to false | `bool` | `false` | no |
| <a name="input_ebs_iops"></a> [ebs\_iops](#input\_ebs\_iops) | Amount of provisioned IOPS. Only valid for volume\_type of io1, io2 or gp3 | `string` | `null` | no |
| <a name="input_ebs_throughput"></a> [ebs\_throughput](#input\_ebs\_throughput) | Throughput to provision for a volume in mebibytes per second (MiB/s). This is only valid for volume\_type of gp3. | `string` | `null` | no |
| <a name="input_ebs_volume_size"></a> [ebs\_volume\_size](#input\_ebs\_volume\_size) | Size of the volume in gibibytes (GiB). | `string` | `null` | no |
| <a name="input_ebs_volume_type"></a> [ebs\_volume\_type](#input\_ebs\_volume\_type) | Type of volume. Valid values include standard, gp2, gp3, io1, io2, sc1, or st1. | `string` | `null` | no |
| <a name="input_ec2_userdata_file_path"></a> [ec2\_userdata\_file\_path](#input\_ec2\_userdata\_file\_path) | User data for instance which run script for starting instance | `string` | `""` | no |
| <a name="input_iam_policy_json_file"></a> [iam\_policy\_json\_file](#input\_iam\_policy\_json\_file) | IAM policy arn or json file, if json file true else false | `string` | `false` | no |
| <a name="input_iam_policy_json_file_path"></a> [iam\_policy\_json\_file\_path](#input\_iam\_policy\_json\_file\_path) | JSON file path if iam policy json file is true | `string` | `null` | no |
| <a name="input_instance_ami"></a> [instance\_ami](#input\_instance\_ami) | Instance ami | `string` | `null` | no |
| <a name="input_instance_profile_name"></a> [instance\_profile\_name](#input\_instance\_profile\_name) | Name of the instance profile | `string` | `null` | no |
| <a name="input_instance_role_name"></a> [instance\_role\_name](#input\_instance\_role\_name) | Instance role name | `string` | `null` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Instance type to use for the instance | `string` | `null` | no |
| <a name="input_key_pair_name"></a> [key\_pair\_name](#input\_key\_pair\_name) | The name for the key pair | `string` | `null` | no |
| <a name="input_policy_arn"></a> [policy\_arn](#input\_policy\_arn) | Policy arn for IAM group | `string` | `null` | no |
| <a name="input_root_ebs_delete_on_termination"></a> [root\_ebs\_delete\_on\_termination](#input\_root\_ebs\_delete\_on\_termination) | Whether the volume should be destroyed on instance termination. Defaults to true | `bool` | `true` | no |
| <a name="input_root_ebs_encryption"></a> [root\_ebs\_encryption](#input\_root\_ebs\_encryption) | Whether to enable volume encryption. Defaults to false | `bool` | `true` | no |
| <a name="input_root_ebs_iops"></a> [root\_ebs\_iops](#input\_root\_ebs\_iops) | Amount of provisioned IOPS. Only valid for volume\_type of io1, io2 or gp3 | `string` | `null` | no |
| <a name="input_root_ebs_throughput"></a> [root\_ebs\_throughput](#input\_root\_ebs\_throughput) | Throughput to provision for a volume in mebibytes per second (MiB/s). This is only valid for volume\_type of gp3. | `string` | `null` | no |
| <a name="input_root_ebs_volume_name"></a> [root\_ebs\_volume\_name](#input\_root\_ebs\_volume\_name) | EBS volume name | `string` | `null` | no |
| <a name="input_root_ebs_volume_type"></a> [root\_ebs\_volume\_type](#input\_root\_ebs\_volume\_type) | Type of volume. Valid values include standard, gp2, gp3, io1, io2, sc1, or st1. | `string` | `null` | no |
| <a name="input_root_volume_size"></a> [root\_volume\_size](#input\_root\_volume\_size) | Size of the volume in gibibytes (GiB). | `string` | `null` | no |
| <a name="input_security_group_inbound_port"></a> [security\_group\_inbound\_port](#input\_security\_group\_inbound\_port) | security group inbound port | `set(string)` | `[]` | no |
| <a name="input_security_group_name"></a> [security\_group\_name](#input\_security\_group\_name) | security group for EC2 instance | `string` | `null` | no |
| <a name="input_sg_ip_protocol"></a> [sg\_ip\_protocol](#input\_sg\_ip\_protocol) | security group inbound ip protocol | `string` | `null` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | VPC Subnet ID to launch in | `string` | `null` | no |
| <a name="input_user_data_requried_or_not"></a> [user\_data\_requried\_or\_not](#input\_user\_data\_requried\_or\_not) | user data requried or not | `bool` | `false` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC id | `string` | `null` | no |
| <a name="input_vpc_ipv4_cidr_block"></a> [vpc\_ipv4\_cidr\_block](#input\_vpc\_ipv4\_cidr\_block) | VPC ipv4 cidr block | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_instance_id"></a> [instance\_id](#output\_instance\_id) | n/a |
| <a name="output_sg_id"></a> [sg\_id](#output\_sg\_id) | n/a |