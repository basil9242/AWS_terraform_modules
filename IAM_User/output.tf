output "password" {
  value = aws_iam_user_login_profile.iam_user_login.encrypted_password
}

output "MFA_qr" {
  value = aws_iam_virtual_mfa_device.MFA_virtual.qr_code_png
}