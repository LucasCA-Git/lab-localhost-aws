resource "aws_cloudwatch_event_rule" "daily_job" {
  name = "daily-job"

  schedule_expression = "rate(1 day)"
}

resource "aws_cloudwatch_event_target" "sqs_target" {
  rule = aws_cloudwatch_event_rule.daily_job.name

  target_id = "SendToSQS"

  arn = var.sqs_queue_arn
}
