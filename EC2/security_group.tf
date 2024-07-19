resource "aws_security_group" "allow_tls" {
  name        = var.security_group_name
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = var.vpc_id

  tags = {
    Name = var.security_group_name
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  for_each = var.security_group_inbound_port
  cidr_ipv4 = var.vpc_ipv4_cidr_block
  from_port         = each.value
  ip_protocol       = var.sg_ip_protocol
  to_port           = each.value
}