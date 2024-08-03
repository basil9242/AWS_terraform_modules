provider "aws" {
    region = "ap-south-1"
}

module "vpc" {
    source = "git::https://github.com/basil9242/AWS_terraform_modules.git//VPC"
    vpc_name = "test_vpc"
    vpc_cloudwatch_logs_group_name = "vpc_flow"
    vpc_logs_role_name = "vpc_flow_role"
    cidr_block_vpc = "10.0.0.0/16"
    private_subnet = [
        {
            name = "private_subnet-1"
            cidr_block = "10.0.3.0/24"
            availability_zone  = "ap-south-1a"
        },
        {
            name = "private_subnet-2"
            cidr_block = "10.0.2.0/24"
            availability_zone  = "ap-south-1b"
        }
    ]
    public_subnet = [
        {
            name = "public_subnet-1"
            cidr_block = "10.0.0.0/24"
            availability_zone  = "ap-south-1c"
        },
        {
            name = "public_subnet-2"
            cidr_block = "10.0.1.0/24"
            availability_zone  = "ap-south-1a"
        }
    ]
}