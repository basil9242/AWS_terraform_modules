resource "aws_iam_group" "iam_group" {
  name = var.iam_group_name
  path = var.iam_group_path
}

resource "aws_iam_policy" "iam_policy-group" {
    name = "iam_policy_group"
    description = "Json policy for IAM Group"
    policy = file(var.iam_group_policy_json_file_path)
}

resource "aws_iam_group_policy_attachment" "iam_policy_attach_group" {
    count = var.iam_group_yes_no ? 0:1
    group = aws_iam_group.iam_group.name
    policy_arn = var.iam_policy_json_file ? 1 [aws_iam_policy.iam_policy_group.arn] : [var.policy_arn]
}