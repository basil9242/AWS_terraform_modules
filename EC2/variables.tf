variable "instance_name" {
  description = "Instance name"
  type        = string
  validation {
    condition     = var.instance_name != null && length(var.instance_name) > 0
    error_message = "Instance name must be provided and cannot be empty."
  }
}

variable "instance_ami" {
  description = "Instance AMI ID"
  type        = string
  validation {
    condition     = var.instance_ami != null && can(regex("^ami-[0-9a-f]{8,17}$", var.instance_ami))
    error_message = "Instance AMI must be a valid AMI ID (ami-xxxxxxxx)."
  }
}

variable "instance_type" {
  description = "Instance type to use for the instance"
  type        = string
  validation {
    condition     = var.instance_type != null && length(var.instance_type) > 0
    error_message = "Instance type must be provided and cannot be empty."
  }
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
  type        = number
  default     = null
}

variable "root_ebs_volume_name" {
    description = "EBS volume name"
    type = string
    default = null  
}

variable "root_ebs_throughput" {
  description = "Throughput to provision for a volume in mebibytes per second (MiB/s). This is only valid for volume_type of gp3."
  type        = number
  default     = null
}

variable "root_volume_size" {
  description = "Size of the volume in gibibytes (GiB)."
  type        = number
  default     = 20
  validation {
    condition     = var.root_volume_size >= 8 && var.root_volume_size <= 16384
    error_message = "Root volume size must be between 8 and 16384 GiB."
  }
}

variable "ebs_device_name" {
    description = "Name of the device to mount."
    type = string
    default = null
}

variable "attach_ebs_required" {
  description = "Whether to attach additional EBS volume to EC2 instance (other than root EBS volume)"
  type        = bool
  default     = false
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
  description = "Whether to attach IAM role to instance"
  type        = bool
  default     = false
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

variable "user_data_required" {
  description = "Whether user data is required"
  type        = bool
  default     = false
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
# Monitoring and Environment
variable "enable_detailed_monitoring" {
  description = "Whether to enable detailed monitoring for the instance"
  type        = bool
  default     = false
}

variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
  default     = {}
}

# Volume type validation
variable "root_ebs_volume_type" {
  description = "Type of volume. Valid values include standard, gp2, gp3, io1, io2, sc1, or st1."
  type        = string
  default     = "gp3"
  validation {
    condition     = contains(["standard", "gp2", "gp3", "io1", "io2", "sc1", "st1"], var.root_ebs_volume_type)
    error_message = "Root EBS volume type must be one of: standard, gp2, gp3, io1, io2, sc1, st1."
  }
}