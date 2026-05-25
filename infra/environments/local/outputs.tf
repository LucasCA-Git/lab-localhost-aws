output "raw_bucket" {
  value = module.s3.raw_bucket
}

output "sqs_queue" {
  value = module.sqs.queue_name
}

output "ecs_cluster" {
  value = module.ecs.cluster_name
}
