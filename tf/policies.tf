data "aws_iam_policy_document" "sns-publish" {
  statement {
    actions   = ["sns:Publish"]
    resources = [aws_sns_topic.this.arn]
    effect    = "Allow"
  }
}

data "aws_iam_policy_document" "apigw-proxy-lambda" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    effect = "Allow"
  }
}

data "aws_iam_policy_document" "apigw-proxy-cloudwatch" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["apigateway.amazonaws.com"]
    }
    effect = "Allow"
  }
}

data "aws_iam_policy_document" "sns-publish-sqs" {
  for_each = var.consumers

  statement {
    actions = ["sqs:SendMessage"]
    principals {
      type        = "Service"
      identifiers = ["sns.amazonaws.com"]
    }
    effect = "Allow"
    condition {
      test     = "ArnEquals"
      variable = "aws:SourceArn"
      values   = [aws_sns_topic.this.arn]
    }
    resources = ["arn:aws:sqs:${var.region}:${data.aws_caller_identity.current.account_id}:${var.name}-${var.environment}-${each.value}"]
  }
}
