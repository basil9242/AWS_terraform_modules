resource "aws_internet_gateway" "igw" {
  tags = {
    Name = "vpc_ig"
  }
}

resource "aws_internet_gateway_attachment" "attach_igw" {
  internet_gateway_id = aws_internet_gateway.igw.id
  vpc_id              = aws_vpc.vpc.id
}
