output "vpc_id" {
    value = aws_vpc.vpc.id
}

output "public_subnet" {
    value = [for subnet in aws_subnet.vpc_public_subnet : subnet.id]
}

output "private_subnet" {
    value = [for subnet in aws_subnet.vpc_private_subnet : subnet.id]
}

