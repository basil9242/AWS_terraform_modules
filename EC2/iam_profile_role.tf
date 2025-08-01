resource "aws_iam_instance_profile" "instance_profile" {
  count = var.attach_role_instance ? 1 : 0
  name  = var.instance_profile_name
  role  = aws_iam_role.instance_role[0].name
  
  tags = merge(var.tags, {
    Name = var.instance_profile_name
  })
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
  count              = var.attach_role_instance ? 1 : 0
  name               = var.instance_role_name
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
  
  tags = merge(var.tags, {
    Name = var.instance_role_name
  })
}

resource "aws_iam_policy" "iam_policy" {
  count       = var.attach_role_instance && var.iam_policy_json_file ? 1 : 0
  name        = "${var.instance_name}-policy"
  description = "Custom policy for EC2 instance"
  policy      = file(var.iam_policy_json_file_path)
  
  tags = merge(var.tags, {
    Name = "${var.instance_name}-policy"
  })
}

resource "aws_iam_role_policy_attachment" "attach_policy_role" {
  count      = var.attach_role_instance && var.iam_policy_json_file ? 1 : 0
  role       = aws_iam_role.instance_role[0].name
  policy_arn = aws_iam_policy.iam_policy[0].arn
}

resource "aws_iam_role_policy_attachment" "attach_policy_arn_role" {
  count      = var.attach_role_instance && !var.iam_policy_json_file && var.policy_arn != null ? 1 : 0
  role       = aws_iam_role.instance_role[0].name
  policy_arn = var.policy_arn
}