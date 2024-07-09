resource "aws_iam_group" "iam_group" {
  name = var.iam_group_name
  path = var.iam_group_path
}

resource "aws_iam_policy" "iam_policy_group" {
    count = var.iam_policy_json_file ? 1:0
    name = "iam_policy_group"
    description = "Json policy for IAM Group"
    policy = file(var.iam_group_policy_json_file_path)
}

resource "aws_iam_group_policy_attachment" "iam_policy_attach_group" {
    count = var.iam_policy_json_file ? 0:1
    group = aws_iam_group.iam_group.name
    policy_arn = aws_iam_policy.iam_policy_group[count.index].arn
}

resource "aws_iam_policy" "iam_group_file_policy" {
  count = var.iam_policy_json_file ? 1:0
  name = "iam_group_policy_${count.index}"
  description = "IAM policy for IAM User Group"
  policy = jsondecode(var.iam_group_policy_json_file_path)
}

resource "aws_iam_group_policy_attachment" "iam_policy_file_attach_group" {
    count = var.iam_policy_json_file ? 1:0
    group = aws_iam_group.iam_group.name
    policy_arn = aws_iam_policy.iam_group_file_policy[count.index].arn
}

resource "aws_iam_policy" "MFA_policy" {
  name        = "MFA_policy"
  path        = var.iam_group_path
  description = "MFA_policy"
  policy = jsonencode(
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Sid": "VisualEditor0",
                "Effect": "Allow",
                "Action": [
                    "iam:EnableMFADevice",
                    "iam:CreateVirtualMFADevice"
                ],
                "Resource": aws_iam_group.iam_group.arn,
                "Condition": {
                    "Bool": {
                        "aws:MultiFactorAuthPresent": "true"
                    }
                }
            }
        ]
    }
  )
}

resource "aws_iam_group_policy_attachment" "iam_group_policy_attachment" {
  group      = aws_iam_group.iam_group.name
  policy_arn = aws_iam_policy.MFA_policy.arn
}