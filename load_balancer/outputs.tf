output "load_balancer_id" {
  description = "The ID and ARN of the load balancer"
  value       = aws_lb.main.id
}

output "load_balancer_arn" {
  description = "The ARN of the load balancer"
  value       = aws_lb.main.arn
}

output "load_balancer_arn_suffix" {
  description = "The ARN suffix for use with CloudWatch Metrics"
  value       = aws_lb.main.arn_suffix
}

output "load_balancer_dns_name" {
  description = "The DNS name of the load balancer"
  value       = aws_lb.main.dns_name
}

output "load_balancer_zone_id" {
  description = "The canonical hosted zone ID of the load balancer"
  value       = aws_lb.main.zone_id
}

output "target_group_arns" {
  description = "ARNs of the target groups"
  value       = aws_lb_target_group.main[*].arn
}

output "target_group_arn_suffixes" {
  description = "ARN suffixes of target groups for use with CloudWatch Metrics"
  value       = aws_lb_target_group.main[*].arn_suffix
}

output "target_group_names" {
  description = "Names of the target groups"
  value       = aws_lb_target_group.main[*].name
}

output "http_listener_arn" {
  description = "The ARN of the HTTP listener"
  value       = var.enable_http_listener ? aws_lb_listener.http[0].arn : null
}

output "https_listener_arn" {
  description = "The ARN of the HTTPS listener"
  value       = var.enable_https_listener ? aws_lb_listener.https[0].arn : null
}

output "listener_rule_arns" {
  description = "The ARNs of the listener rules"
  value       = aws_lb_listener_rule.main[*].arn
}