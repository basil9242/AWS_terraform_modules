output "MFA_qr" {
  value = aws_iam_virtual_mfa_device.MFA_virtual.qr_code_png
}

output "password_credentials" {
  value = {
    for k, v in local.users : k => {
      "password" = data.pgp_decrypt.user_password_decrypt[k].plaintext
    }
  }
  sensitive = true
}