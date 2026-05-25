output "eventbridge_rule" {
  value = aws_cloudwatch_event_rule.daily_job.name
}
