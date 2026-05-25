resource "aws_sqs_queue" "main" {
  name = "s3-event-notification-queue"
}
