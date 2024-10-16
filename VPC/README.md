## AWS VPC Terraform module

Terraform module which creates VPC resources on AWS.

## Usage

```hcl
provider "aws" {
    region = "ap-south-1"
}

module "vpc" {
    source = "git::https://github.com/basil9242/AWS_terraform_modules.git//VPC"
    vpc_name = "test_vpc"
    vpc_cloudwatch_logs_group_name = "vpc_flow"
    vpc_logs_role_name = "vpc_flow_role"
    cidr_block_vpc = "10.0.0.0/16"
    private_subnet = [
        {
            name = "private_subnet-1"
            cidr_block = "10.0.3.0/24"
            availability_zone  = "ap-south-1a"
        },
        {
            name = "private_subnet-2"
            cidr_block = "10.0.2.0/24"
            availability_zone  = "ap-south-1b"
        }
    ]
    public_subnet = [
        {
            name = "public_subnet-1"
            cidr_block = "10.0.0.0/24"
            availability_zone  = "ap-south-1c"
        },
        {
            name = "public_subnet-2"
            cidr_block = "10.0.1.0/24"
            availability_zone  = "ap-south-1a"
        }
    ]
}
```

This module is designed to provision a Virtual Private Cloud (VPC) in AWS. A VPC provides an isolated virtual network environment within the AWS ecosystem, allowing for custom-defined network configurations. This module will create a VPC with subnets, route tables, and internet gateways based on user specifications.

## Features

1. Provision a new VPC.
2. Create public and private subnets.
3. Set up Route Tables.
4. Configure Network Access Control Lists (ACLs).
5. Establish an Internet Gateway.
6. Enable NAT Gateway for private subnet instances to access the internet.
7. Associate Elastic IP with NAT Gateway.
8. Support for VPC Flow Logs for network traffic monitoring.


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
| [aws_eip.nat](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_flow_log.vpc_flow_log](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/flow_log) | resource |
| [aws_iam_role.vpc_logs_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.vpc_logs_iam_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_internet_gateway.igw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_internet_gateway_attachment.attach_igw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway_attachment) | resource |
| [aws_kms_alias.alias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.vpc_kms_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_kms_key_policy.vpc_kms_key_ploicy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key_policy) | resource |
| [aws_nat_gateway.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_route_table.main_route_table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.public_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_subnet.vpc_private_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.vpc_public_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.vpc_logs_assume_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.vpc_logs_assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cidr_block_vpc"></a> [cidr\_block\_vpc](#input\_cidr\_block\_vpc) | CIDR block for VPC | `string` | `""` | no |
| <a name="input_enable_dns_hostnames"></a> [enable\_dns\_hostnames](#input\_enable\_dns\_hostnames) | A boolean flag to enable/disable DNS hostnames in the VPC | `bool` | `false` | no |
| <a name="input_private_subnet"></a> [private\_subnet](#input\_private\_subnet) | cidr block, availability zone, name for private subnet | <pre>list(object({<br>      name = string<br>      cidr_block = string<br>      availability_zone = string<br>    }))</pre> | <pre>[<br>  {<br>    "availability_zone": "",<br>    "cidr_block": "",<br>    "name": ""<br>  }<br>]</pre> | no |
| <a name="input_public_subnet"></a> [public\_subnet](#input\_public\_subnet) | cidr block, availability zone, name for public subnet | <pre>list(object({<br>      name = string<br>      cidr_block = string<br>      availability_zone = string<br>    }))</pre> | <pre>[<br>  {<br>    "availability_zone": "",<br>    "cidr_block": "",<br>    "name": ""<br>  }<br>]</pre> | no |
| <a name="input_vpc_cloudwatch_logs_group_name"></a> [vpc\_cloudwatch\_logs\_group\_name](#input\_vpc\_cloudwatch\_logs\_group\_name) | vpc flow logs cloudwatch group name | `string` | `""` | no |
| <a name="input_vpc_instance_tenancy"></a> [vpc\_instance\_tenancy](#input\_vpc\_instance\_tenancy) | A tenancy option for instances launched into the VPCu | `string` | `"default"` | no |
| <a name="input_vpc_logs_role_name"></a> [vpc\_logs\_role\_name](#input\_vpc\_logs\_role\_name) | VPC flow logs IAM role | `string` | `""` | no |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | VPC name | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_private_subnet"></a> [private\_subnet](#output\_private\_subnet) | n/a |
| <a name="output_public_subnet"></a> [public\_subnet](#output\_public\_subnet) | n/a |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | n/a |