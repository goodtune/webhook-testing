resource "aws_sqs_queue" "consumers" {
  for_each                  = var.consumers
  name                      = "${var.name}-${var.environment}-${each.value}"
  message_retention_seconds = 86400
  policy                    = data.aws_iam_policy_document.sns-publish-sqs[each.value].json
  receive_wait_time_seconds = 20
  tags = {
    Service     = "${var.name}-${var.environment}"
    Environment = var.environment
    Region      = var.region
  }
}
