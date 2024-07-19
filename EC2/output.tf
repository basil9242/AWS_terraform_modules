output "instance_id" {
    value = aws_instance.instances.arn
}

output "sg_id" {
    value = aws_security_group.allow_tls.id  
}