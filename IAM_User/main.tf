resource "aws_iam_user" "iam_user" {
  name = var.iam_user_name
  path = var.iam_user_path
  tags =  var.iam_user_tags
}

resource "aws_iam_access_key" "lb" {
  user = aws_iam_user.iam_user.name
}

data "aws_iam_policy_document" "lb_ro" {
  statement {
    effect    = "Allow"
    actions   = ["ec2:Describe*"]
    resources = ["*"]
  }
}

resource "aws_iam_user_policy" "lb_ro" {
  name   = "test"
  user   = aws_iam_user.iam_user.name
  policy = data.aws_iam_policy_document.lb_ro.json
}

