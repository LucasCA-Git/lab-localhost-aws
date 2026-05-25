variable "project_name" {
  type = string
}

variable "ecs_execution_role_arn" {
  type = string
}

variable "log_group_name" {
  type = string
}

variable "sqs_queue_name" {
  type = string
}

variable "api_flask_repository" {
  type = string
}
