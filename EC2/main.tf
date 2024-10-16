resource "aws_instance" "instances" {
    ami = var.instance_ami
    instance_type = var.instance_type
    subnet_id = var.subnet_id
    associate_public_ip_address = var.associate_public_ip_address
    availability_zone = var.availability_zone
    root_block_device {
      delete_on_termination = var.root_ebs_delete_on_termination
      encrypted = var.root_ebs_encryption
      iops = var.root_ebs_iops
      kms_key_id = aws_kms_key.ebs_kms.id
      tags = {
        Name = var.root_ebs_volume_name
      }
      throughput = var.root_ebs_throughput
      volume_size = var.root_volume_size
      volume_type = var.root_ebs_volume_type
    }
    
    iam_instance_profile = var.attach_role_instance ? aws_iam_instance_profile.instance_profile[0].name : null
    key_name = aws_key_pair.kp.key_name
    security_groups = [aws_security_group.allow_tls.id]
    user_data = var.user_data_requried_or_not ? base64encode(file(var.ec2_userdata_file_path)) : 0
    metadata_options {
      http_tokens = "required"
    }
    tags = {
      name = var.instance_name
    }
}