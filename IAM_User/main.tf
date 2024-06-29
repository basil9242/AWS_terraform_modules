resource "aws_iam_user" "iam_user" {
  name = var.iam_user_name
  path = var.iam_user_path
  tags =  var.iam_user_tags
}

resource "aws_iam_user_login_profile" "iam_user_login" {
  user    = aws_iam_user.iam_user.name
  pgp_key = "keybase:some_person_that_exists"
}


resource "aws_iam_group_membership" "iam_group_member" {
  count = var.iam_group_yes_no ? 1:0
  name = var.iam_user_policy_name
  users = [
    aws_iam_group.iam_group.name
  ]
  group = aws_iam_user.iam_user.name
}

resource "aws_iam_user_policy" "iam_user_policy" {
  count = var.iam_group_yes_no ? 0:1
  user = aws_iam_group.iam_group.name
  policy = file(var.iam_user_policy_json_file_path)
  
}