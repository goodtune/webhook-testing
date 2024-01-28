
resource "aws_api_gateway_rest_api" "sns-proxy" {
  name        = "${var.name}-${var.environment}-sns-proxy"
  description = "REST API endpoint that invokes Lambda function to verify signatures and publish to SNS topic"
}

resource "aws_api_gateway_documentation_part" "sns-ingest" {
  location {
    type   = "METHOD"
    method = "POST"
    path   = "/${aws_api_gateway_resource.sns-ingest.path_part}"
  }

  properties = jsonencode({
    "description" : "Invokes Lambda function to verify signatures and publish to SNS topic",
  })
  rest_api_id = aws_api_gateway_rest_api.sns-proxy.id
}

resource "aws_api_gateway_resource" "sns-ingest" {
  rest_api_id = aws_api_gateway_rest_api.sns-proxy.id
  parent_id   = aws_api_gateway_rest_api.sns-proxy.root_resource_id
  path_part   = "ingest"
}

resource "aws_api_gateway_method" "sns-ingest" {
  rest_api_id   = aws_api_gateway_rest_api.sns-proxy.id
  resource_id   = aws_api_gateway_resource.sns-ingest.id
  authorization = "NONE"
  http_method   = "POST"
}

resource "aws_api_gateway_integration" "sns-publish" {
  rest_api_id             = aws_api_gateway_rest_api.sns-proxy.id
  resource_id             = aws_api_gateway_resource.sns-ingest.id
  http_method             = aws_api_gateway_method.sns-ingest.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda.invoke_arn
}

resource "aws_api_gateway_deployment" "sns-proxy" {
  rest_api_id = aws_api_gateway_rest_api.sns-proxy.id
  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.sns-ingest.id,
      aws_api_gateway_method.sns-ingest.id,
      aws_api_gateway_integration.sns-publish.id,
    ]))
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "sns-proxy" {
  depends_on = [aws_cloudwatch_log_group.this]

  deployment_id = aws_api_gateway_deployment.sns-proxy.id
  rest_api_id   = aws_api_gateway_rest_api.sns-proxy.id
  stage_name    = var.environment
  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.this.arn
    format = jsonencode({
      "requestId" : "$context.requestId",
      "extendedRequestId" : "$context.extendedRequestId",
      "ip" : "$context.identity.sourceIp",
      "caller" : "$context.identity.caller",
      "user" : "$context.identity.user",
      "requestTime" : "$context.requestTime",
      "httpMethod" : "$context.httpMethod",
      "resourcePath" : "$context.resourcePath",
      "status" : "$context.status",
      "protocol" : "$context.protocol",
      "responseLength" : "$context.responseLength"
    })
  }
  tags = {
    Environment = var.environment
  }
}
