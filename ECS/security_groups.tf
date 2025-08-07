# Security Group for ECS Service
resource "aws_security_group" "ecs_service_sg" {
  count       = var.create_service && var.create_security_group ? 1 : 0
  name        = "${var.service_name}-sg"
  description = "Security group for ECS service ${var.service_name}"
  vpc_id      = var.vpc_id

  tags = merge(var.tags, {
    Name        = "${var.service_name}-sg"
    Environment = var.environment
  })
}

# Ingress Rules
resource "aws_vpc_security_group_ingress_rule" "ecs_service_ingress" {
  count           = var.create_service && var.create_security_group ? length(var.security_group_ingress_rules) : 0
  security_group_id = aws_security_group.ecs_service_sg[0].id

  cidr_ipv4   = var.security_group_ingress_rules[count.index].cidr_ipv4
  from_port   = var.security_group_ingress_rules[count.index].from_port
  to_port     = var.security_group_ingress_rules[count.index].to_port
  ip_protocol = var.security_group_ingress_rules[count.index].ip_protocol
  description = var.security_group_ingress_rules[count.index].description

  tags = merge(var.tags, {
    Name = "${var.service_name}-ingress-${count.index}"
  })
}

# Egress Rules
resource "aws_vpc_security_group_egress_rule" "ecs_service_egress" {
  count           = var.create_service && var.create_security_group ? length(var.security_group_egress_rules) : 0
  security_group_id = aws_security_group.ecs_service_sg[0].id

  cidr_ipv4   = var.security_group_egress_rules[count.index].cidr_ipv4
  from_port   = var.security_group_egress_rules[count.index].from_port
  to_port     = var.security_group_egress_rules[count.index].to_port
  ip_protocol = var.security_group_egress_rules[count.index].ip_protocol
  description = var.security_group_egress_rules[count.index].description

  tags = merge(var.tags, {
    Name = "${var.service_name}-egress-${count.index}"
  })
}

# Default egress rule (allow all outbound traffic)
resource "aws_vpc_security_group_egress_rule" "ecs_service_default_egress" {
  count           = var.create_service && var.create_security_group && var.allow_all_egress ? 1 : 0
  security_group_id = aws_security_group.ecs_service_sg[0].id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
  description = "Allow all outbound traffic"

  tags = merge(var.tags, {
    Name = "${var.service_name}-default-egress"
  })
}