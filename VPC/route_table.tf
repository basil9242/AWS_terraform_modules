resource "aws_route_table" "main_route_table" {
    vpc_id = aws_vpc.vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
    tags = {
        Name = "public_route_table"
    }
}

resource "aws_route_table_association" "public_subnet" {
  for_each = aws_subnet.vpc_public_subnet
  subnet_id      = each.value.id
  route_table_id = aws_route_table.main_route_table.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id
  
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }
  
  tags = {
    Name = "private_route_table"
  }
}

resource "aws_route_table_association" "private" {
  for_each = aws_subnet.vpc_private_subnet
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private.id
}