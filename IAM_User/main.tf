locals {
  users = {
    "username" = {
      name  = var.iam_user_name
      email = var.iam_user_email
    }
  }
}

resource "aws_iam_user" "iam_user" {
  name = var.iam_user_name
  path = var.iam_user_path
  tags =  var.iam_user_tags
}

resource "aws_iam_access_key" "user_access_key" {
  user       = var.iam_user_name
  depends_on = [aws_iam_user.iam_user]
}

resource "pgp_key" "user_login_key" {
  for_each = local.users
  name    = each.value.name
  email   = each.value.email
  comment = "PGP Key for ${each.value.name}"
}

resource "aws_iam_user_login_profile" "user_login" {
  for_each = local.users
  user                    = var.iam_user_name
  pgp_key                 = pgp_key.user_login_key[each.key].public_key_base64
  password_reset_required = true
  depends_on = [aws_iam_user.iam_user, pgp_key.user_login_key]
}

data "pgp_decrypt" "user_password_decrypt" {
  for_each = local.users
  ciphertext          = aws_iam_user_login_profile.user_login[each.key].encrypted_password
  ciphertext_encoding = "base64"
  private_key         = pgp_key.user_login_key[each.key].private_key
}

resource "aws_iam_virtual_mfa_device" "MFA_virtual" {
  virtual_mfa_device_name = "MFA_virtual"
}

resource "aws_iam_group_membership" "iam_group_member" {
  name = var.iam_group_member_name
  group = aws_iam_group.iam_group.name
  users = [aws_iam_user.iam_user.name]
}
