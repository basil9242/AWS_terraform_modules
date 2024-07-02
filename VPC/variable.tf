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
variable "cidr_block_subnet" {
    description = "Subnet for cidr block"
    type = list(string)
    default = []
}

variable "availability_zone" {
    description = "availability zone for subnet"
    type = list(string)
    default = []  
}

variable "subnet_name" {
    description = "Subnet names"
    type = list(string)
    default = []
}

variable "route_table_name" {
    description = "Route table name"
    type = string
    default = ""  
}