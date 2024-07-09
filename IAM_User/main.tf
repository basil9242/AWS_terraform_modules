resource "aws_iam_user" "iam_user" {
  name = var.iam_user_name
  path = var.iam_user_path
  tags =  var.iam_user_tags
}

resource "aws_iam_virtual_mfa_device" "MFA_virtual" {
  virtual_mfa_device_name = "MFA_virtual"
}

resource "aws_iam_user_login_profile" "iam_user_login" {
  user    = aws_iam_user.iam_user.name
  pgp_key = "keybase:some_person_that_exists"
}


resource "aws_iam_group_membership" "iam_group_member" {
  name = var.iam_user_policy_name
  users = [
    aws_iam_group.iam_group.name
  ]
  group = aws_iam_user.iam_user.name
}
