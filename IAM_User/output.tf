output "password_credentials" {
  value = {
    for k, v in local.users : k => {
      "password" = data.pgp_decrypt.user_password_decrypt[k].plaintext
    }
  }
  sensitive = true
}

output "iam_user_arn" {
  value = aws_iam_user.iam_user.arn
  
}