# VPC Outputs
output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.vpc.id
}

output "vpc_arn" {
  description = "ARN of the VPC"
  value       = aws_vpc.vpc.arn
}

output "vpc_cidr_block" {
  description = "CIDR block of the VPC"
  value       = aws_vpc.vpc.cidr_block
}

# Subnet Outputs
output "public_subnet_ids" {
  description = "List of IDs of the public subnets"
  value       = aws_subnet.public_subnets[*].id
}

output "private_subnet_ids" {
  description = "List of IDs of the private subnets"
  value       = aws_subnet.private_subnets[*].id
}

output "public_subnet_arns" {
  description = "List of ARNs of the public subnets"
  value       = aws_subnet.public_subnets[*].arn
}

output "private_subnet_arns" {
  description = "List of ARNs of the private subnets"
  value       = aws_subnet.private_subnets[*].arn
}

# Gateway Outputs
output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = var.create_internet_gateway ? aws_internet_gateway.igw[0].id : null
}

output "nat_gateway_ids" {
  description = "List of IDs of the NAT Gateways"
  value       = var.create_nat_gateway ? aws_nat_gateway.nat_gateways[*].id : []
}

output "nat_gateway_public_ips" {
  description = "List of public Elastic IPs of the NAT Gateways"
  value       = var.create_nat_gateway ? aws_eip.nat_eips[*].public_ip : []
}

# Route Table Outputs
output "public_route_table_id" {
  description = "ID of the public route table"
  value       = var.create_internet_gateway ? aws_route_table.public_rt[0].id : null
}

output "private_route_table_ids" {
  description = "List of IDs of the private route tables"
  value       = aws_route_table.private_rt[*].id
}

# Flow Logs Outputs
output "vpc_flow_log_id" {
  description = "ID of the VPC Flow Log"
  value       = var.enable_flow_logs ? aws_flow_log.vpc_flow_log[0].id : null
}

output "vpc_flow_log_cloudwatch_log_group_name" {
  description = "Name of the CloudWatch Log Group for VPC Flow Logs"
  value       = var.enable_flow_logs ? aws_cloudwatch_log_group.vpc_cloudwatch_logs_group[0].name : null
}