resource "aws_ecr_repository" "api_flask" {
  name = "api-flask"

  force_delete = true
}

resource "aws_ecr_repository" "api_node" {
  name = "api-node"

  force_delete = true
}

resource "aws_ecr_repository" "worker" {
  name = "worker"

  force_delete = true
}
