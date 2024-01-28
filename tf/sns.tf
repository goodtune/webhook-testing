resource "aws_sns_topic" "this" {
  name         = "${var.name}-${var.environment}"
  display_name = "Fanout topic for webhook events from ${var.name}-${var.environment}"
  tags = {
    Service     = "${var.name}-${var.environment}"
    Environment = var.environment
  }
}

resource "aws_sns_topic_subscription" "consumers" {
  for_each  = var.consumers
  topic_arn = aws_sns_topic.this.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.consumers[each.value].arn
}
