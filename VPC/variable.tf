#VPC
variable "cidr_block_vpc" {
    description = "CIDR block for VPC"
    type = string
    default = ""  
}

variable "vpc_instance_tenancy" {
    description = "A tenancy option for instances launched into the VPCu"
    type = string
    default = "default"  
}

variable "vpc_name" {
    description = "VPC name"
    type = string
    default = ""  
}

variable "enable_dns_hostnames" {
    description = "A boolean flag to enable/disable DNS hostnames in the VPC"
    type = bool
    default = false  
}

#subnet
variable "public_subnet" {
    description = "cidr block, availability zone, name for public subnet"
    type = list(object({
      name = string
      cidr_block = string
      availability_zone = string
    }))
    default = [
        {
            name = ""
            cidr_block = ""
            availability_zone = ""
        }
    ]
}

variable "private_subnet" {
    description = "cidr block, availability zone, name for private subnet"
    type = list(object({
      name = string
      cidr_block = string
      availability_zone = string
    }))
    default = [
        {
            name = ""
            cidr_block = ""
            availability_zone = ""
        }
    ]
}

variable "vpc_cloudwatch_logs_group_name" {
  description = "vpc flow logs cloudwatch group name"
  type = string
  default = ""
}

variable "vpc_logs_role_name" {
    description = "VPC flow logs IAM role"
    type = string
    default = ""
}