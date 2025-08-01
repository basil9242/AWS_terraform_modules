output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.instances.id
}

output "instance_arn" {
  description = "ARN of the EC2 instance"
  value       = aws_instance.instances.arn
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.instances.public_ip
}

output "instance_private_ip" {
  description = "Private IP address of the EC2 instance"
  value       = aws_instance.instances.private_ip
}

output "instance_public_dns" {
  description = "Public DNS name of the EC2 instance"
  value       = aws_instance.instances.public_dns
}

output "instance_private_dns" {
  description = "Private DNS name of the EC2 instance"
  value       = aws_instance.instances.private_dns
}

output "security_group_id" {
  description = "ID of the security group"
  value       = aws_security_group.allow_tls.id
}

output "security_group_arn" {
  description = "ARN of the security group"
  value       = aws_security_group.allow_tls.arn
}

output "key_pair_name" {
  description = "Name of the key pair"
  value       = aws_key_pair.kp.key_name
}

output "iam_role_arn" {
  description = "ARN of the IAM role"
  value       = var.attach_role_instance ? aws_iam_role.instance_role[0].arn : null
}

output "iam_instance_profile_name" {
  description = "Name of the IAM instance profile"
  value       = var.attach_role_instance ? aws_iam_instance_profile.instance_profile[0].name : null
}