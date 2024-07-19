resource "aws_ebs_volume" "ebs_volume_instance" {
    count = var.attach_ebs_requried_or_not ? 1:0
    availability_zone = var.ebs_availability_zone
    encrypted = var.ebs_encryption
    final_snapshot = var.ebs_final_snapshot
    iops = var.ebs_iops
    size = var.ebs_volume_size
    type = var.ebs_volume_type
    tags = {
        Name = var.ebs_device_name
    }
    throughput = var.ebs_throughput  
}

resource "aws_volume_attachment" "ebs_attach_instance" {
    count = var.attach_ebs_requried_or_not ? 1:0
    device_name = var.ebs_device_name
    volume_id = aws_ebs_volume.ebs_volume_instance[0].id
    instance_id = aws_instance.instances.id
}