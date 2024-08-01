resource "aws_subnet" "vpc_public_subnet" {
    vpc_id = aws_vpc.vpc.id
    
    for_each = { for idx, subnet in var.public_subnet : idx => subnet }
    cidr_block = each.value.cidr_block
    availability_zone = each.value.availability_zone
    map_public_ip_on_launch = true

    tags = {
        Name = each.value.name
    }
}

resource "aws_subnet" "vpc_private_subnet" {
    vpc_id = aws_vpc.vpc.id
    
    for_each = { for idx, subnet in var.private_subnet : idx => subnet }
    cidr_block = each.value.cidr_block
    availability_zone = each.value.availability_zone

    tags = {
        Name = each.value.name
    }
}