terraform {
  required_providers {
    aws = {}
  }
}

data "aws_caller_identity" "current" {}
