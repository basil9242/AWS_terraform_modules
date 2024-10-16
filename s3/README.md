## AWS S3 Bucket Terraform module

Terraform module which creates S3 Bucket resources on AWS.

## Usage

```hcl
provider "aws" {
    region = "ap-south-1"
}

module "s3" {
    source = "git::https://github.com/basil9242/AWS_terraform_modules.git//s3"
    bucket_name = "s3-bucket-basil"
    bucket_acl = "public-read"
    s3_bucket_website_configuration_requried = true
    s3_website_index_document = "index.html"
    s3_website_error_document = "error.html"
}
```

This module is designed to provision an Amazon Simple Storage Service (S3) bucket in AWS. An S3 bucket provides scalable object storage in the AWS cloud, allowing users to store and retrieve any amount of data with high durability and availability. This module will create an S3 bucket based on user specifications, including bucket name, versioning, ACL.

## Features
1. Provision a new S3 bucket.
2. Set bucket policies and permissions.
3. Enable versioning for object storage.
4. Enable static website configuration.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.59.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_kms_alias.kms_alias_s3_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.s3_kms](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_kms_key_policy.s3_poicy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key_policy) | resource |
| [aws_s3_bucket.s3_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_policy.allow_access_for_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.s3_bucket_public_access_block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.s3_bucket_server_side_encryption_configuration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_versioning.s3_bucket_versioning](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_s3_bucket_website_configuration.s3_bucket_website_configuration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_website_configuration) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bucket_acl"></a> [bucket\_acl](#input\_bucket\_acl) | Amazon S3 access control lists (ACLs) enable you to manage access to buckets and objects. Valid values are private, public-read, public-read-write, aws-exec-read, authenticated-read, and log-delivery-write | `string` | `"private-read"` | no |
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | Name of the bucket | `string` | `""` | no |
| <a name="input_bucket_object_destroy"></a> [bucket\_object\_destroy](#input\_bucket\_object\_destroy) | Boolean that indicates all objects (including any locked objects) should be deleted from the bucket when the bucket is destroyed so that the bucket can be destroyed without error | `bool` | `false` | no |
| <a name="input_s3_block_public_acls"></a> [s3\_block\_public\_acls](#input\_s3\_block\_public\_acls) | Whether Amazon S3 should block public ACLs for this bucket | `bool` | `true` | no |
| <a name="input_s3_block_public_policy"></a> [s3\_block\_public\_policy](#input\_s3\_block\_public\_policy) | Whether Amazon S3 should block public bucket policies for this bucket | `bool` | `true` | no |
| <a name="input_s3_bucket_policy_json_file_path"></a> [s3\_bucket\_policy\_json\_file\_path](#input\_s3\_bucket\_policy\_json\_file\_path) | bucket policy file path | `string` | `null` | no |
| <a name="input_s3_bucket_policy_requried"></a> [s3\_bucket\_policy\_requried](#input\_s3\_bucket\_policy\_requried) | apply the policy to bucket | `bool` | `false` | no |
| <a name="input_s3_bucket_versioning"></a> [s3\_bucket\_versioning](#input\_s3\_bucket\_versioning) | Configuration block for the versioning parameters. Values are Enabled ,Disabled | `string` | `"Enabled"` | no |
| <a name="input_s3_bucket_website_configuration_requried"></a> [s3\_bucket\_website\_configuration\_requried](#input\_s3\_bucket\_website\_configuration\_requried) | S3 bucket website configuration resource requried or not | `bool` | `false` | no |
| <a name="input_s3_ignore_public_acls"></a> [s3\_ignore\_public\_acls](#input\_s3\_ignore\_public\_acls) | Whether Amazon S3 should ignore public ACLs for this bucket | `bool` | `true` | no |
| <a name="input_s3_restrict_public_buckets"></a> [s3\_restrict\_public\_buckets](#input\_s3\_restrict\_public\_buckets) | Whether Amazon S3 should restrict public bucket policies for this bucket | `bool` | `true` | no |
| <a name="input_s3_website_error_document"></a> [s3\_website\_error\_document](#input\_s3\_website\_error\_document) | Name of the error document for the website. | `string` | `"error.html"` | no |
| <a name="input_s3_website_index_document"></a> [s3\_website\_index\_document](#input\_s3\_website\_index\_document) | Name of the index document for the website | `string` | `"index.html"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_s3_bucket_arn"></a> [s3\_bucket\_arn](#output\_s3\_bucket\_arn) | n/a |
| <a name="output_s3_bucket_kms_arn"></a> [s3\_bucket\_kms\_arn](#output\_s3\_bucket\_kms\_arn) | n/a |