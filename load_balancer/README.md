# Load Balancer Terraform Module

This module creates an AWS Application Load Balancer (ALB) with associated target groups, listeners, and listener rules.

## Features

- Application Load Balancer with customizable configuration
- Multiple target groups support
- HTTP and HTTPS listeners
- Listener rules for advanced routing
- Target group attachments
- Access logging support
- SSL/TLS termination
- Health checks configuration
- Session stickiness

## Usage

### Basic Example

```hcl
module "load_balancer" {
  source = "./load_balancer"

  name            = "my-alb"
  security_groups = [aws_security_group.alb.id]
  subnets         = [aws_subnet.public_1.id, aws_subnet.public_2.id]
  vpc_id          = aws_vpc.main.id

  target_groups = [{
    name     = "web-servers"
    port     = 80
    protocol = "HTTP"
    health_check = {
      enabled             = true
      healthy_threshold   = 2
      interval            = 30
      matcher             = "200"
      path                = "/health"
      port                = "traffic-port"
      protocol            = "HTTP"
      timeout             = 5
      unhealthy_threshold = 2
    }
    stickiness = {
      type            = "lb_cookie"
      cookie_duration = 86400
      enabled         = false
    }
  }]

  tags = {
    Environment = "production"
    Project     = "web-app"
  }
}
```

### HTTPS with SSL Certificate

```hcl
module "load_balancer" {
  source = "./load_balancer"

  name            = "my-alb"
  security_groups = [aws_security_group.alb.id]
  subnets         = [aws_subnet.public_1.id, aws_subnet.public_2.id]
  vpc_id          = aws_vpc.main.id

  enable_https_listener    = true
  http_redirect_to_https   = true
  certificate_arn          = aws_acm_certificate.main.arn
  ssl_policy              = "ELBSecurityPolicy-TLS-1-2-2017-01"

  target_groups = [{
    name     = "web-servers"
    port     = 80
    protocol = "HTTP"
    health_check = {
      enabled             = true
      healthy_threshold   = 2
      interval            = 30
      matcher             = "200"
      path                = "/health"
      port                = "traffic-port"
      protocol            = "HTTP"
      timeout             = 5
      unhealthy_threshold = 2
    }
    stickiness = {
      type            = "lb_cookie"
      cookie_duration = 86400
      enabled         = false
    }
  }]

  tags = {
    Environment = "production"
    Project     = "web-app"
  }
}
```

### Multiple Target Groups with Listener Rules

```hcl
module "load_balancer" {
  source = "./load_balancer"

  name            = "my-alb"
  security_groups = [aws_security_group.alb.id]
  subnets         = [aws_subnet.public_1.id, aws_subnet.public_2.id]
  vpc_id          = aws_vpc.main.id

  enable_https_listener  = true
  certificate_arn        = aws_acm_certificate.main.arn

  target_groups = [
    {
      name     = "web-servers"
      port     = 80
      protocol = "HTTP"
      health_check = {
        enabled             = true
        healthy_threshold   = 2
        interval            = 30
        matcher             = "200"
        path                = "/health"
        port                = "traffic-port"
        protocol            = "HTTP"
        timeout             = 5
        unhealthy_threshold = 2
      }
      stickiness = {
        type            = "lb_cookie"
        cookie_duration = 86400
        enabled         = false
      }
    },
    {
      name     = "api-servers"
      port     = 8080
      protocol = "HTTP"
      health_check = {
        enabled             = true
        healthy_threshold   = 2
        interval            = 30
        matcher             = "200"
        path                = "/api/health"
        port                = "traffic-port"
        protocol            = "HTTP"
        timeout             = 5
        unhealthy_threshold = 2
      }
      stickiness = {
        type            = "lb_cookie"
        cookie_duration = 86400
        enabled         = false
      }
    }
  ]

  listener_rules = [
    {
      listener_type = "https"
      priority      = 100
      action = {
        type               = "forward"
        target_group_index = 1
        redirect           = null
        fixed_response     = null
      }
      conditions = [
        {
          field            = "path-pattern"
          values           = ["/api/*"]
          http_header_name = null
          query_string     = null
        }
      ]
    }
  ]

  target_attachments = [
    {
      target_group_index = 0
      target_id          = aws_instance.web1.id
      port               = 80
    },
    {
      target_group_index = 0
      target_id          = aws_instance.web2.id
      port               = 80
    },
    {
      target_group_index = 1
      target_id          = aws_instance.api1.id
      port               = 8080
    }
  ]

  tags = {
    Environment = "production"
    Project     = "web-app"
  }
}
```

### With Access Logging

```hcl
module "load_balancer" {
  source = "./load_balancer"

  name            = "my-alb"
  security_groups = [aws_security_group.alb.id]
  subnets         = [aws_subnet.public_1.id, aws_subnet.public_2.id]
  vpc_id          = aws_vpc.main.id

  access_logs_enabled = true
  access_logs_bucket  = aws_s3_bucket.alb_logs.bucket
  access_logs_prefix  = "alb-logs"

  target_groups = [{
    name     = "web-servers"
    port     = 80
    protocol = "HTTP"
    health_check = {
      enabled             = true
      healthy_threshold   = 2
      interval            = 30
      matcher             = "200"
      path                = "/health"
      port                = "traffic-port"
      protocol            = "HTTP"
      timeout             = 5
      unhealthy_threshold = 2
    }
    stickiness = {
      type            = "lb_cookie"
      cookie_duration = 86400
      enabled         = false
    }
  }]

  tags = {
    Environment = "production"
    Project     = "web-app"
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| aws | >= 4.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 4.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | Name of the load balancer | `string` | n/a | yes |
| security_groups | A list of security group IDs to assign to the LB | `list(string)` | n/a | yes |
| subnets | A list of subnet IDs to attach to the LB | `list(string)` | n/a | yes |
| vpc_id | VPC ID where the load balancer will be created | `string` | n/a | yes |
| internal | If true, the LB will be internal | `bool` | `false` | no |
| enable_deletion_protection | If true, deletion of the load balancer will be disabled via the AWS API | `bool` | `false` | no |
| enable_http2 | Indicates whether HTTP/2 is enabled in application load balancers | `bool` | `true` | no |
| enable_cross_zone_load_balancing | If true, cross-zone load balancing of the load balancer will be enabled | `bool` | `false` | no |
| access_logs_bucket | The S3 bucket name to store the logs in | `string` | `""` | no |
| access_logs_prefix | The S3 bucket prefix | `string` | `""` | no |
| access_logs_enabled | Boolean to enable / disable access_logs | `bool` | `false` | no |
| target_groups | List of target group configurations | `list(object)` | See variables.tf | no |
| enable_http_listener | Enable HTTP listener | `bool` | `true` | no |
| enable_https_listener | Enable HTTPS listener | `bool` | `false` | no |
| http_redirect_to_https | Redirect HTTP traffic to HTTPS | `bool` | `false` | no |
| ssl_policy | The name of the SSL Policy for the listener | `string` | `"ELBSecurityPolicy-TLS-1-2-2017-01"` | no |
| certificate_arn | The ARN of the default SSL server certificate | `string` | `""` | no |
| listener_rules | List of listener rule configurations | `list(object)` | `[]` | no |
| target_attachments | List of target attachments | `list(object)` | `[]` | no |
| tags | A map of tags to assign to the resource | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| load_balancer_id | The ID and ARN of the load balancer |
| load_balancer_arn | The ARN of the load balancer |
| load_balancer_arn_suffix | The ARN suffix for use with CloudWatch Metrics |
| load_balancer_dns_name | The DNS name of the load balancer |
| load_balancer_zone_id | The canonical hosted zone ID of the load balancer |
| target_group_arns | ARNs of the target groups |
| target_group_arn_suffixes | ARN suffixes of target groups for use with CloudWatch Metrics |
| target_group_names | Names of the target groups |
| http_listener_arn | The ARN of the HTTP listener |
| https_listener_arn | The ARN of the HTTPS listener |
| listener_rule_arns | The ARNs of the listener rules |

## Security Considerations

1. **Security Groups**: Ensure proper security group rules are configured
2. **SSL/TLS**: Use strong SSL policies and valid certificates
3. **Access Logs**: Enable access logging for audit and monitoring
4. **Internal vs External**: Choose appropriate load balancer type based on requirements
5. **Health Checks**: Configure appropriate health check paths and intervals

## Best Practices

1. Use HTTPS listeners with valid SSL certificates
2. Enable access logging for monitoring and troubleshooting
3. Configure appropriate health checks for your applications
4. Use listener rules for advanced routing requirements
5. Enable deletion protection for production load balancers
6. Tag resources appropriately for cost allocation and management