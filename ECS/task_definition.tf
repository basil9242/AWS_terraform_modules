# ECS Task Definition
resource "aws_ecs_task_definition" "ecs_task_definition" {
  count                    = var.create_service ? 1 : 0
  family                   = var.task_definition_family
  network_mode             = var.network_mode
  requires_compatibilities = var.requires_compatibilities
  cpu                      = var.task_cpu
  memory                   = var.task_memory
  execution_role_arn       = aws_iam_role.ecs_execution_role[0].arn
  task_role_arn           = var.create_task_role ? aws_iam_role.ecs_task_role[0].arn : null

  container_definitions = jsonencode([
    {
      name      = var.container_name
      image     = var.container_image
      cpu       = var.container_cpu
      memory    = var.container_memory
      essential = true

      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = var.launch_type == "FARGATE" ? var.container_port : 0
          protocol      = "tcp"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.ecs_logs[0].name
          "awslogs-region"        = data.aws_region.current.name
          "awslogs-stream-prefix" = "ecs"
        }
      }

      environment = [
        for key, value in var.environment_variables : {
          name  = key
          value = value
        }
      ]

      secrets = [
        for secret in var.secrets : {
          name      = secret.name
          valueFrom = secret.valueFrom
        }
      ]

      healthCheck = var.enable_health_check ? {
        command     = var.health_check_command
        interval    = var.health_check_interval
        timeout     = var.health_check_timeout
        retries     = var.health_check_retries
        startPeriod = var.health_check_start_period
      } : null

      mountPoints = [
        for mount in var.mount_points : {
          sourceVolume  = mount.sourceVolume
          containerPath = mount.containerPath
          readOnly      = mount.readOnly
        }
      ]

      volumesFrom = var.volumes_from

      linuxParameters = var.enable_linux_parameters ? {
        capabilities = {
          add  = var.linux_capabilities_add
          drop = var.linux_capabilities_drop
        }
        devices = var.linux_devices
        initProcessEnabled = var.init_process_enabled
        maxSwap = var.max_swap
        sharedMemorySize = var.shared_memory_size
        swappiness = var.swappiness
        tmpfs = var.tmpfs
      } : null

      ulimits = var.ulimits

      dockerLabels = var.docker_labels

      dependsOn = var.container_depends_on
    }
  ])

  dynamic "volume" {
    for_each = var.volumes
    content {
      name      = volume.value.name
      host_path = volume.value.host_path

      dynamic "docker_volume_configuration" {
        for_each = volume.value.docker_volume_configuration != null ? [volume.value.docker_volume_configuration] : []
        content {
          scope         = docker_volume_configuration.value.scope
          autoprovision = docker_volume_configuration.value.autoprovision
          driver        = docker_volume_configuration.value.driver
          driver_opts   = docker_volume_configuration.value.driver_opts
          labels        = docker_volume_configuration.value.labels
        }
      }

      dynamic "efs_volume_configuration" {
        for_each = volume.value.efs_volume_configuration != null ? [volume.value.efs_volume_configuration] : []
        content {
          file_system_id          = efs_volume_configuration.value.file_system_id
          root_directory          = efs_volume_configuration.value.root_directory
          transit_encryption      = efs_volume_configuration.value.transit_encryption
          transit_encryption_port = efs_volume_configuration.value.transit_encryption_port

          dynamic "authorization_config" {
            for_each = efs_volume_configuration.value.authorization_config != null ? [efs_volume_configuration.value.authorization_config] : []
            content {
              access_point_id = authorization_config.value.access_point_id
              iam             = authorization_config.value.iam
            }
          }
        }
      }

      dynamic "fsx_windows_file_server_volume_configuration" {
        for_each = volume.value.fsx_windows_file_server_volume_configuration != null ? [volume.value.fsx_windows_file_server_volume_configuration] : []
        content {
          file_system_id = fsx_windows_file_server_volume_configuration.value.file_system_id
          root_directory = fsx_windows_file_server_volume_configuration.value.root_directory

          authorization_config {
            credentials_parameter = fsx_windows_file_server_volume_configuration.value.authorization_config.credentials_parameter
            domain               = fsx_windows_file_server_volume_configuration.value.authorization_config.domain
          }
        }
      }
    }
  }

  dynamic "placement_constraints" {
    for_each = var.placement_constraints
    content {
      type       = placement_constraints.value.type
      expression = placement_constraints.value.expression
    }
  }

  dynamic "proxy_configuration" {
    for_each = var.proxy_configuration != null ? [var.proxy_configuration] : []
    content {
      type           = proxy_configuration.value.type
      container_name = proxy_configuration.value.container_name
      properties     = proxy_configuration.value.properties
    }
  }

  dynamic "inference_accelerator" {
    for_each = var.inference_accelerators
    content {
      device_name = inference_accelerator.value.device_name
      device_type = inference_accelerator.value.device_type
    }
  }

  tags = merge(var.tags, {
    Name        = var.task_definition_family
    Environment = var.environment
  })
}