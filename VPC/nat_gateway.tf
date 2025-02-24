# Create a NAT Gateway Elastic IP
resource "aws_eip" "nat" {
  vpc = true
}

# Create the NAT Gateway
resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.vpc_public_subnet[0].id
  
  tags = {
    Name = "main-nat-gateway"
  }
  depends_on = [ aws_eip.nat, aws_internet_gateway_attachment.attach_igw, aws_route_table.main_route_table ]
}
