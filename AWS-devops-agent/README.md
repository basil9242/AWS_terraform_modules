## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.0 |
| <a name="provider_awscc"></a> [awscc](#provider\_awscc) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

### Basic AWS Devops agent

```hcl
module "devopsagent_basic" {
  source = "./"

  agent_space_name    = "my-devops-agent"
  aws_region          = "eu-central-1"
  tags = {
    Environment = "production"
    Project     = "devops"
    ManagedBy   = "terraform"
  }
}
```
## Resources

| Name | Type |
|------|------|
| [aws_iam_role.devops_agentspace](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.devops_operator](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.devops_agentspace_inline](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.devops_agentspace_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.devops_operator_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [awscc_devopsagent_agent_space.agent_space](https://registry.terraform.io/providers/hashicorp/awscc/latest/docs/resources/devopsagent_agent_space) | resource |
| [awscc_devopsagent_association.agent_association](https://registry.terraform.io/providers/hashicorp/awscc/latest/docs/resources/devopsagent_association) | resource |
| [random_id.suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [aws_iam_policy_document.devops_agentspace_inline](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.devops_agentspace_trust](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.devops_operator_trust](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_agent_response_language"></a> [agent\_response\_language](#input\_agent\_response\_language) | The language for agent responses | `string` | `"en-US"` | no |
| <a name="input_agent_space_name"></a> [agent\_space\_name](#input\_agent\_space\_name) | The name of the AgentSpace | `string` | `null` | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The AWS region to deploy resources | `string` | `null` | yes |
| <a name="input_service_account_id"></a> [service\_account\_id](#input\_service\_account\_id) | The AWS account ID for the service account | `string` | `null` | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags for services | `map(string)` | `{}` | no |