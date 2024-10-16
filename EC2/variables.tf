variable "instance_name" {
    description = "Instance name"
    type = string
    default = null
}

variable "instance_ami" {
    description = "Instance ami"
    type = string
    default = null  
}

variable "instance_type" {
    description = "Instance type to use for the instance"
    type = string
    default = null
}

variable "subnet_id" {
    description = "VPC Subnet ID to launch in"
    type = string
    default = null 
}

variable "associate_public_ip_address" {
    description = "Whether to associate a public IP address with an instance in a VPC"
    type = bool
    default = false
}

variable "availability_zone" {
    description = "AZ to start the instance in"
    type = string
    default = null  
}

variable "root_ebs_delete_on_termination" {
    description = "Whether the volume should be destroyed on instance termination. Defaults to true"
    type = bool
    default = true
}

variable "root_ebs_encryption" {
    description = "Whether to enable volume encryption. Defaults to false"
    type = bool
    default = true 
}

variable "root_ebs_iops" {
    description = "Amount of provisioned IOPS. Only valid for volume_type of io1, io2 or gp3"
    type = string
    default = null  
}

variable "root_ebs_volume_name" {
    description = "EBS volume name"
    type = string
    default = null  
}

variable "root_ebs_throughput" {
    description = "Throughput to provision for a volume in mebibytes per second (MiB/s). This is only valid for volume_type of gp3."
    type = string
    default = null 
}

variable "root_volume_size" {
    description = "Size of the volume in gibibytes (GiB)."
    type = string
    default = null 
}

variable "root_ebs_volume_type" {
    description = "Type of volume. Valid values include standard, gp2, gp3, io1, io2, sc1, or st1."
    type = string
    default = null 
}

variable "ebs_device_name" {
    description = "Name of the device to mount."
    type = string
    default = null
}

variable "attach_ebs_requried_or_not" {
    description = "Attach EBS volume to EC2 instance other than root EBS volume requried"
    type = bool
    default = false
}

variable "ebs_encryption" {
    description = "Whether to enable volume encryption. Defaults to false"
    type = bool
    default = false  
}

variable "ebs_iops" {
    description = "Amount of provisioned IOPS. Only valid for volume_type of io1, io2 or gp3"
    type = string
    default = null  
}

variable "ebs_throughput" {
    description = "Throughput to provision for a volume in mebibytes per second (MiB/s). This is only valid for volume_type of gp3."
    type = string
    default = null 
}

variable "ebs_volume_size" {
    description = "Size of the volume in gibibytes (GiB)."
    type = string
    default = null 
}

variable "ebs_volume_type" {
    description = "Type of volume. Valid values include standard, gp2, gp3, io1, io2, sc1, or st1."
    type = string
    default = null 
}

variable "attach_role_instance" {
    description = "Attach iam role to instance, if requried true else false"
    type = string
    default = false  
}

variable "instance_profile_name" {
    description = "Name of the instance profile"
    type = string
    default = null  
}

variable "instance_role_name" {
    description = "Instance role name"
    type = string
    default = null  
}

variable "iam_policy_json_file" {
    description = "IAM policy arn or json file, if json file true else false"
    type = string
    default = false
}

variable "key_pair_name" {
    description = "The name for the key pair"
    type = string
    default = null
}

variable "iam_policy_json_file_path" {
    description = "JSON file path if iam policy json file is true"
    type = string
    default = null
}

variable "policy_arn" {
    description = "Policy arn for IAM group"
    type = string
    default = null  
}

variable "security_group_name" {
    description = "security group for EC2 instance"
    type = string
    default = null  
}

variable "security_group_inbound_port" {
    description = "security group inbound port"
    type = set(string)
    default = [ ]  
}

variable "sg_ip_protocol" {
    description = "security group inbound ip protocol"
    type = string
    default = null  
}

variable "ec2_userdata_file_path" {
    description = "User data for instance which run script for starting instance"
    type = string
    default = "" 
}

variable "vpc_id" {
    description = "VPC id"
    type = string
    default = null
}

variable "vpc_ipv4_cidr_block" {
    description = "VPC ipv4 cidr block"
    type = string
    default = null  
}

variable "user_data_requried_or_not" {
    description = "user data requried or not"
    type = bool
    default = false  
}

variable "ebs_availability_zone" {
    description = "The AZ where the EBS volume will exist."
    type = string
    default = null  
}

variable "ebs_final_snapshot" {
    description = "If true, snapshot will be created before volume deletion. Any tags on the volume will be migrated to the snapshot. By default set to false"
    type = bool
    default = false  
}