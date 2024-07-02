resource "aws_route_table" "route_table" {
    vpc_id = aws_vpc.vpc.id
    route {
        cidr_block = var.cidr_block_vpc
        gateway_id = "will define"
    }
    tags = {
        Name = var.route_table_name
    }
  
}