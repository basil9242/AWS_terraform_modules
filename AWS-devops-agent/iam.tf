resource "random_id" "suffix" {
  byte_length = 4
}

data "aws_iam_policy_document" "devops_agentspace_trust" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["aidevops.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }
    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = ["arn:aws:aidevops:${var.aws_region}:${data.aws_caller_identity.current.account_id}:agentspace/*"]
    }
  }
}

data "aws_iam_policy_document" "devops_agentspace_inline" {
  statement {
    effect    = "Allow"
    actions   = ["iam:CreateServiceLinkedRole"]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "devops_agentspace_inline" {
  name   = "AllowCreateServiceLinkedRoles"
  role   = aws_iam_role.devops_agentspace.id
  policy = data.aws_iam_policy_document.devops_agentspace_inline.json
}

resource "aws_iam_role" "devops_agentspace" {
  name               = "DevOpsAgentRole-AgentSpace-${random_id.suffix.hex}"
  assume_role_policy = data.aws_iam_policy_document.devops_agentspace_trust.json
}

resource "aws_iam_role_policy_attachment" "devops_agentspace_access" {
  role       = aws_iam_role.devops_agentspace.name
  policy_arn = "arn:aws:iam::aws:policy/AIDevOpsAgentAccessPolicy"
}

data "aws_iam_policy_document" "devops_operator_trust" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["aidevops.amazonaws.com"]
    }

    actions = ["sts:AssumeRole", "sts:TagSession"]

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }

    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = ["arn:aws:aidevops:${var.aws_region}:${data.aws_caller_identity.current.account_id}:agentspace/*"]
    }
  }
}

resource "aws_iam_role" "devops_operator" {
  name               = "DevOpsAgentRole-WebappAdmin-${random_id.suffix.hex}"
  assume_role_policy = data.aws_iam_policy_document.devops_operator_trust.json
}

resource "aws_iam_role_policy_attachment" "devops_operator_access" {
  role       = aws_iam_role.devops_operator.name
  policy_arn = "arn:aws:iam::aws:policy/AIDevOpsOperatorAppAccessPolicy"
}