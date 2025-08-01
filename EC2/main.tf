resource "aws_instance" "instances" {
  ami                         = var.instance_ami
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  associate_public_ip_address = var.associate_public_ip_address
  availability_zone           = var.availability_zone
  
  root_block_device {
    delete_on_termination = var.root_ebs_delete_on_termination
    encrypted             = var.root_ebs_encryption
    iops                  = var.root_ebs_iops
    kms_key_id            = aws_kms_key.ebs_kms.id
    throughput            = var.root_ebs_throughput
    volume_size           = var.root_volume_size
    volume_type           = var.root_ebs_volume_type
    
    tags = merge(var.tags, {
      Name = var.root_ebs_volume_name
    })
  }
  
  iam_instance_profile   = var.attach_role_instance ? aws_iam_instance_profile.instance_profile[0].name : null
  key_name               = aws_key_pair.kp.key_name
  vpc_security_group_ids = [aws_security_group.allow_tls.id]
  user_data              = var.user_data_required ? base64encode(file(var.ec2_userdata_file_path)) : null
  
  metadata_options {
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    http_endpoint               = "enabled"
    instance_metadata_tags      = "enabled"
  }
  
  monitoring = var.enable_detailed_monitoring
  
  tags = merge(var.tags, {
    Name        = var.instance_name
    Environment = var.environment
  })
  
  lifecycle {
    create_before_destroy = true
  }
}
