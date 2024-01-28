resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.region}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.sns-proxy.id}/*/${aws_api_gateway_method.sns-ingest.http_method}${aws_api_gateway_resource.sns-ingest.path}"
}

data "archive_file" "lambda" {
  type        = "zip"
  output_path = "lambda.zip"
  source_file = "lambda.py"
}

resource "aws_lambda_function" "lambda" {
  description   = "Perform signature verification of webhook and publish to SNS topic ${aws_sns_topic.this.name}"
  filename      = data.archive_file.lambda.output_path
  function_name = "${var.name}-sns-publish-${var.environment}"
  handler       = "lambda.handler"
  runtime       = "python3.10"
  role          = aws_iam_role.assume-lambda.arn
  publish       = true
  environment {
    variables = {
      "GITHUB_SECRET" = var.secret
      "TOPIC_ARN"     = aws_sns_topic.this.arn
    }
  }
  source_code_hash = data.archive_file.lambda.output_base64sha256
}
