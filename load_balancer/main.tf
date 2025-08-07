# Application Load Balancer
resource "aws_lb" "main" {
  name               = var.name
  internal           = var.internal
  load_balancer_type = "application"
  security_groups    = var.security_groups
  subnets            = var.subnets

  enable_deletion_protection       = var.enable_deletion_protection
  enable_http2                     = var.enable_http2
  enable_cross_zone_load_balancing = var.enable_cross_zone_load_balancing

  access_logs {
    bucket  = var.access_logs_bucket
    prefix  = var.access_logs_prefix
    enabled = var.access_logs_enabled
  }

  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )
}

# Target Group
resource "aws_lb_target_group" "main" {
  count = length(var.target_groups)

  name     = var.target_groups[count.index].name
  port     = var.target_groups[count.index].port
  protocol = var.target_groups[count.index].protocol
  vpc_id   = var.vpc_id

  health_check {
    enabled             = var.target_groups[count.index].health_check.enabled
    healthy_threshold   = var.target_groups[count.index].health_check.healthy_threshold
    interval            = var.target_groups[count.index].health_check.interval
    matcher             = var.target_groups[count.index].health_check.matcher
    path                = var.target_groups[count.index].health_check.path
    port                = var.target_groups[count.index].health_check.port
    protocol            = var.target_groups[count.index].health_check.protocol
    timeout             = var.target_groups[count.index].health_check.timeout
    unhealthy_threshold = var.target_groups[count.index].health_check.unhealthy_threshold
  }

  stickiness {
    type            = var.target_groups[count.index].stickiness.type
    cookie_duration = var.target_groups[count.index].stickiness.cookie_duration
    enabled         = var.target_groups[count.index].stickiness.enabled
  }

  tags = merge(
    var.tags,
    {
      Name = var.target_groups[count.index].name
    }
  )
}

# HTTP Listener
resource "aws_lb_listener" "http" {
  count = var.enable_http_listener ? 1 : 0

  load_balancer_arn = aws_lb.main.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = var.http_redirect_to_https ? "redirect" : "forward"

    dynamic "redirect" {
      for_each = var.http_redirect_to_https ? [1] : []
      content {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }

    dynamic "forward" {
      for_each = var.http_redirect_to_https ? [] : [1]
      content {
        target_group {
          arn = aws_lb_target_group.main[0].arn
        }
      }
    }
  }

  tags = var.tags
}

# HTTPS Listener
resource "aws_lb_listener" "https" {
  count = var.enable_https_listener ? 1 : 0

  load_balancer_arn = aws_lb.main.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = var.ssl_policy
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main[0].arn
  }

  tags = var.tags
}

# Listener Rules
resource "aws_lb_listener_rule" "main" {
  count = length(var.listener_rules)

  listener_arn = var.listener_rules[count.index].listener_type == "https" ? aws_lb_listener.https[0].arn : aws_lb_listener.http[0].arn
  priority     = var.listener_rules[count.index].priority

  action {
    type             = var.listener_rules[count.index].action.type
    target_group_arn = var.listener_rules[count.index].action.target_group_index != null ? aws_lb_target_group.main[var.listener_rules[count.index].action.target_group_index].arn : null

    dynamic "redirect" {
      for_each = var.listener_rules[count.index].action.type == "redirect" ? [var.listener_rules[count.index].action.redirect] : []
      content {
        host        = redirect.value.host
        path        = redirect.value.path
        port        = redirect.value.port
        protocol    = redirect.value.protocol
        query       = redirect.value.query
        status_code = redirect.value.status_code
      }
    }

    dynamic "fixed_response" {
      for_each = var.listener_rules[count.index].action.type == "fixed-response" ? [var.listener_rules[count.index].action.fixed_response] : []
      content {
        content_type = fixed_response.value.content_type
        message_body = fixed_response.value.message_body
        status_code  = fixed_response.value.status_code
      }
    }
  }

  dynamic "condition" {
    for_each = var.listener_rules[count.index].conditions
    content {
      dynamic "path_pattern" {
        for_each = condition.value.field == "path-pattern" ? [condition.value] : []
        content {
          values = path_pattern.value.values
        }
      }

      dynamic "host_header" {
        for_each = condition.value.field == "host-header" ? [condition.value] : []
        content {
          values = host_header.value.values
        }
      }

      dynamic "http_header" {
        for_each = condition.value.field == "http-header" ? [condition.value] : []
        content {
          http_header_name = http_header.value.http_header_name
          values           = http_header.value.values
        }
      }

      dynamic "query_string" {
        for_each = condition.value.field == "query-string" ? condition.value.query_string : []
        content {
          key   = query_string.value.key
          value = query_string.value.value
        }
      }
    }
  }

  tags = var.tags
}

# Target Group Attachments
resource "aws_lb_target_group_attachment" "main" {
  count = length(var.target_attachments)

  target_group_arn = aws_lb_target_group.main[var.target_attachments[count.index].target_group_index].arn
  target_id        = var.target_attachments[count.index].target_id
  port             = var.target_attachments[count.index].port
}
