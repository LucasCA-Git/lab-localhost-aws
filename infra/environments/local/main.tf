module "s3" {
  source = "../../modules/s3"

  project_name = var.project_name
}

module "sqs" {
  source = "../../modules/sqs"

  project_name = var.project_name
}

module "glue" {
  source = "../../modules/glue"

  project_name = var.project_name
}

module "logs" {
  source = "../../modules/logs"

  project_name = var.project_name
}

module "iam" {
  source = "../../modules/iam"

  project_name = var.project_name
}

module "ecr" {
  source = "../../modules/ecr"

  project_name = var.project_name
}

module "ecs" {
  source = "../../modules/ecs"

  project_name           = var.project_name
  ecs_execution_role_arn = module.iam.ecs_execution_role_arn
  log_group_name         = module.logs.log_group_name
  sqs_queue_name         = module.sqs.queue_name
  api_flask_repository   = module.ecr.api_flask_repository
}

module "secrets" {
  source = "../../modules/secrets"

  project_name = var.project_name
}

module "eventbridge" {
  source = "../../modules/eventbridge"

  sqs_queue_arn = module.sqs.queue_arn
}
