# Public Route Table
resource "aws_route_table" "public_rt" {
  count  = var.create_internet_gateway ? 1 : 0
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw[0].id
  }

  tags = merge(var.tags, {
    Name = "${var.vpc_name}-public-rt"
    Type = "Public"
  })
}

# Public Route Table Associations
resource "aws_route_table_association" "public_rta" {
  count          = var.create_internet_gateway ? length(var.public_subnet) : 0
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_rt[0].id
}

# Private Route Tables (one per AZ for NAT Gateway routing)
resource "aws_route_table" "private_rt" {
  count  = length(var.private_subnet)
  vpc_id = aws_vpc.vpc.id

  dynamic "route" {
    for_each = var.create_nat_gateway ? [1] : []
    content {
      cidr_block     = "0.0.0.0/0"
      nat_gateway_id = aws_nat_gateway.nat_gateways[count.index].id
    }
  }

  tags = merge(var.tags, {
    Name = "${var.vpc_name}-private-rt-${count.index + 1}"
    Type = "Private"
  })
}

# Private Route Table Associations
resource "aws_route_table_association" "private_rta" {
  count          = length(var.private_subnet)
  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private_rt[count.index].id
}