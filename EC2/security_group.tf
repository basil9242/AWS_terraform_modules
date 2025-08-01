resource "aws_security_group" "allow_tls" {
  name        = var.security_group_name
  description = "Security group for EC2 instance"
  vpc_id      = var.vpc_id

  tags = merge(var.tags, {
    Name = var.security_group_name
  })
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  for_each          = var.security_group_inbound_port
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = var.vpc_ipv4_cidr_block
  from_port         = tonumber(each.value)
  to_port           = tonumber(each.value)
  ip_protocol       = var.sg_ip_protocol
  
  tags = merge(var.tags, {
    Name = "ingress-${each.value}"
  })
}

resource "aws_vpc_security_group_egress_rule" "allow_all_outbound" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  
  tags = merge(var.tags, {
    Name = "egress-all"
  })
}