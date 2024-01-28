
resource "aws_iam_role" "assume-lambda" {
  name               = "${var.name}-${var.environment}-assume-lambda"
  assume_role_policy = data.aws_iam_policy_document.apigw-proxy-lambda.json
  inline_policy {
    name   = "sns-publish"
    policy = data.aws_iam_policy_document.sns-publish.json
  }
}

resource "aws_iam_role" "assume-cloudwatch" {
  name               = "${var.name}-${var.environment}-assume-cloudwatch"
  assume_role_policy = data.aws_iam_policy_document.apigw-proxy-cloudwatch.json
  inline_policy {
    name   = "sns-proxy"
    policy = data.aws_iam_policy_document.sns-publish.json
  }
}
