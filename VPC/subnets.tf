# Public Subnets
resource "aws_subnet" "public_subnets" {
  count                   = length(var.public_subnet)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet[count.index].cidr_block
  availability_zone       = var.public_subnet[count.index].availability_zone
  map_public_ip_on_launch = true

  tags = merge(var.tags, {
    Name = var.public_subnet[count.index].name
    Type = "Public"
  })
}

# Private Subnets
resource "aws_subnet" "private_subnets" {
  count             = length(var.private_subnet)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnet[count.index].cidr_block
  availability_zone = var.private_subnet[count.index].availability_zone

  tags = merge(var.tags, {
    Name = var.private_subnet[count.index].name
    Type = "Private"
  })
}