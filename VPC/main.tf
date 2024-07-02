resource "aws_vpc" "vpc" {
    cidr_block = var.cidr_block_vpc
    instance_tenancy = var.vpc_instance_tenancy
    enable_dns_hostnames = var.enable_dns_hostnames
    tags = {
      "Name" = var.vpc_name
    }  
}

resource "aws_subnet" "vpc_subnet" {
    vpc_id = aws_vpc.vpc.id
    
    count = length(var.cidr_block_subnet,var.availability_zone,var.subnet_name)
    cidr_block = var.cidr_block_subnet[count.index]
    availability_zone = var.availability_zone[count.index]

    tags = {
        Name = var.subnet_name[count.index]
    }
}