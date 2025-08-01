# Internet Gateway
resource "aws_internet_gateway" "igw" {
  count  = var.create_internet_gateway ? 1 : 0
  vpc_id = aws_vpc.vpc.id

  tags = merge(var.tags, {
    Name = "${var.vpc_name}-igw"
  })
}

# Elastic IPs for NAT Gateways
resource "aws_eip" "nat_eips" {
  count  = var.create_nat_gateway ? length(var.public_subnet) : 0
  domain = "vpc"

  tags = merge(var.tags, {
    Name = "${var.vpc_name}-nat-eip-${count.index + 1}"
  })

  depends_on = [aws_internet_gateway.igw]
}

# NAT Gateways
resource "aws_nat_gateway" "nat_gateways" {
  count         = var.create_nat_gateway ? length(var.public_subnet) : 0
  allocation_id = aws_eip.nat_eips[count.index].id
  subnet_id     = aws_subnet.public_subnets[count.index].id

  tags = merge(var.tags, {
    Name = "${var.vpc_name}-nat-gateway-${count.index + 1}"
  })

  depends_on = [aws_internet_gateway.igw]
}