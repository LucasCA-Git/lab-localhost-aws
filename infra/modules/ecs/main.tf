resource "aws_ecs_cluster" "main" {
  name = "${var.project_name}-cluster"
}

resource "aws_ecs_task_definition" "api_flask" {
  family                   = "api-flask"
  network_mode             = "bridge"
  requires_compatibilities = ["EC2"]

  cpu    = 256
  memory = 512

  execution_role_arn = var.ecs_execution_role_arn

  container_definitions = jsonencode([
    {
      name  = "api-flask"

      image = "${var.api_flask_repository}:latest"

      essential = true

      memory = 512

      portMappings = [
        {
          containerPort = 5000
          hostPort      = 5000
        }
      ]

      environment = [
        {
          name  = "SQS_QUEUE"
          value = var.sqs_queue_name
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"

        options = {
          awslogs-group         = var.log_group_name
          awslogs-region        = "us-east-1"
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "api_flask_service" {
  name = "api-flask-service"

  cluster = aws_ecs_cluster.main.id

  task_definition = aws_ecs_task_definition.api_flask.arn

  desired_count = 1

  launch_type = "EC2"
}
