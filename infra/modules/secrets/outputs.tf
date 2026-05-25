output "mongo_secret_name" {
  value = aws_secretsmanager_secret.mongo_uri.name
}
