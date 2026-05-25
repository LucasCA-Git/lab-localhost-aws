resource "aws_secretsmanager_secret" "mongo_uri" {
  name = "mongo-uri"
}

resource "aws_secretsmanager_secret_version" "mongo_uri_value" {
  secret_id = aws_secretsmanager_secret.mongo_uri.id

  secret_string = jsonencode({
    uri = "mongodb://admin:admin@mongodb:27017"
  })
}
