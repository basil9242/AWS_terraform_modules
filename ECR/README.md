## AWS ECR Terraform module

Terraform module which creates ECR resources on AWS.

## Usage
```hcl
provider "aws" {
    region = "ap-south-1"
}

module "ecr" {
    source = "git::https://github.com/basil9242/AWS_terraform_modules.git//ecr"
    ecr_name = "test"
    ecr_image_tag_mutability = "MUTABLE"
    ecr_repository_policy_requried = true
    ecr_policy_json_file = "./ecr_policy.json"
}
```
#### ecr_policy.json
```json
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "newstatement",
        "Effect": "Allow",
        "Principal": "*",
        "Action": [
          "ecr:BatchDeleteImage",
          "ecr:DeleteLifecyclePolicy",
          "ecr:GetAuthorizationToken"
        ]
      }
    ]
  }
```


# AWS ECR

AWS Elastic Container Registry (ECR) is a fully-managed Docker container registry that allows developers to store, manage, and deploy Docker container images. It's integrated with Amazon Elastic Container Service (ECS), simplifying your development to production workflow. ECR eliminates the need to operate your own container repositories or worry about scaling the underlying infrastructure.

ECR hosts your images in a highly available and scalable architecture, allowing you to reliably deploy containers for your applications. The service supports private Docker repositories with resource-based permissions using AWS Identity and Access Management (IAM) to specify who can access and modify your repositories.

## Key Features of AWS ECR:

### 1. Secure: 
ECR transfers your container images over HTTPS and automatically encrypts your images at rest.
### 2. Scalable: 
You can seamlessly host as many images as you need with the high availability of AWS infrastructure.
### 3. Integrated: 
Works well with AWS services like ECS and AWS Lambda for simplified application development and deployment.
### 4. Reliable:
Backed by Amazon’s massive infrastructure, ensuring high availability and reliability.
### 5. Access Control: 
Fine-grained access control policies allow you to manage permissions at the repository level.

## ECR Policies:

ECR uses policies to manage permissions. These policies are JSON statements that define what actions are allowed or denied on your repositories. There are two types of policies:

### 1. Repository Policies: 
These are resource-based policies that allow you to control who has access to your ECR repositories and what actions they can perform. They are similar to S3 bucket policies and can be used to grant cross-account access.
### 2. IAM Policies: 
These are attached to IAM users, groups, or roles within your AWS account. They specify what actions those entities can perform on all resources in your account, including ECR repositories. IAM policies can be used to enforce user-level permissions.

By combining these policies, you can create a secure environment for managing your Docker containers while leveraging the robustness and scalability of AWS infrastructure.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.61.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ecr_repository.ecr_repository](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository) | resource |
| [aws_ecr_repository_policy.ecr_repository_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository_policy) | resource |
| [aws_kms_alias.alias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.ecr_kms_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_kms_key_policy.ecr_kms_key_ploicy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key_policy) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ecr_image_tag_mutability"></a> [ecr\_image\_tag\_mutability](#input\_ecr\_image\_tag\_mutability) | The tag mutability setting for the repository. Must be one of: MUTABLE or IMMUTABLE. | `string` | `"IMMUTABLE"` | no |
| <a name="input_ecr_name"></a> [ecr\_name](#input\_ecr\_name) | Name of the repository | `string` | `null` | no |
| <a name="input_ecr_policy_json_file"></a> [ecr\_policy\_json\_file](#input\_ecr\_policy\_json\_file) | ECR policy json file path | `string` | `null` | no |
| <a name="input_ecr_repository_policy_requried"></a> [ecr\_repository\_policy\_requried](#input\_ecr\_repository\_policy\_requried) | ECR repository policy is requried not not | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ecr_arn"></a> [ecr\_arn](#output\_ecr\_arn) | ECR arn |