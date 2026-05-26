resource "awscc_devopsagent_agent_space" "agent_space" {
    name = var.agent_space_name
    description = "AgentSpace created by Terraform module"
    operator_app = {
        iam = {
            operator_app_role_arn = aws_iam_role.devops_operator.arn
        }
    }
    depends_on = [
        aws_iam_role.devops_agentspace,
        aws_iam_role_policy_attachment.devops_agentspace_access,
        aws_iam_role_policy.devops_agentspace_inline,
        aws_iam_role.devops_operator,
        aws_iam_role_policy_attachment.devops_operator_access
    ]
}

resource "awscc_devopsagent_association" "agent_association" {
    agent_space_id = awscc_devopsagent_agent_space.agent_space.id
    service_id = "aws"
    configuration = {
        aws = {
            assumable_role_arn = aws_iam_role.devops_agentspace.arn
            account_id         = data.aws_caller_identity.current.account_id
            account_type       = "monitor"
        }
    }
    depends_on = [
        awscc_devopsagent_agent_space.agent_space,
        aws_iam_role.devops_agentspace,
        aws_iam_role_policy_attachment.devops_agentspace_access,
        aws_iam_role_policy.devops_agentspace_inline
    ]
}
