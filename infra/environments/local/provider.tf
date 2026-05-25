provider "aws" {
  access_key = "test"
  secret_key = "test"

  region = var.aws_region

  s3_use_path_style           = true
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints {
    ecs            = "http://localhost:4566"
    ecr            = "http://localhost:4566"
    iam            = "http://localhost:4566"
    logs           = "http://localhost:4566"
    s3             = "http://localhost:4566"
    sqs            = "http://localhost:4566"
    glue           = "http://localhost:4566"
    secretsmanager = "http://localhost:4566"
    events         = "http://localhost:4566"
    cloudwatch     = "http://localhost:4566"
    sts            = "http://localhost:4566"
  }
}
