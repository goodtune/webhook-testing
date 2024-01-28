output "api_gateway_invoke_url" {
  value = "${aws_api_gateway_deployment.sns-proxy.invoke_url}${var.environment}${aws_api_gateway_resource.sns-ingest.path}"
}

output "sqs_url" {
  value = { for consumer in var.consumers : consumer => aws_sqs_queue.consumers[consumer].id }
}
