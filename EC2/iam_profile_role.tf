resource "aws_iam_instance_profile" "instance_profile" {
    count = var.attach_role_instance ? 1:0
    name = var.instance_profile_name
    role = aws_iam_role.instance_role.name
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "instance_role" {
  name               = var.instance_role_name
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_policy" "iam_policy" {
    count = var.iam_policy_json_file ? 1:0
    name = "iam_policy_group"
    description = "Json policy for IAM Group"
    policy = file(var.iam_policy_json_file_path)
}

resource "aws_iam_role_policy_attachment" "attach_policy_role" {
    count = var.iam_policy_json_file ? 1:0
    role = aws_iam_role.instance_role.name
    policy_arn = aws_iam_policy.iam_policy[count.index].arn
}

resource "aws_iam_role_policy_attachment" "attach_policy_arn_role" {
    count = var.iam_policy_json_file ? 0:1
    role = aws_iam_role.instance_role.name
    policy_arn = var.policy_arn 
}