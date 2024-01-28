resource "aws_cloudwatch_log_group" "this" {
  name              = "/service/${var.name}-${var.environment}"
  retention_in_days = 3
  tags = {
    Service     = "${var.name}-${var.environment}"
    Environment = var.environment
  }
}

resource "aws_cloudwatch_log_group" "lambda" {
  name              = "/aws/lambda/${var.name}-sns-publish-${var.environment}"
  retention_in_days = 3
  tags = {
    Service     = "${var.name}-${var.environment}"
    Environment = var.environment
  }
}
