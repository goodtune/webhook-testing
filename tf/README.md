# AWS Solution with Terraform

Inspiration is taken from [Publish to SNS with GitHub webhooks](https://www.oasys.net/posts/publish-to-sns-with-github-webhooks/) post. It arrives at an architecture very close to what I was hoping to achieve.

![image](https://github.com/goodtune/webhook-testing/assets/286798/b9a4cb60-97f0-441d-87b3-07559096b81f)

The main difference is that instead of "audit scripts" running as `lambda` serverless functions at the end, I want to fanout from the SNS topic onto individual SQS queues for in-house applications to subscribe to and consume from.

## Configuration

You will need to populate the `terraform.tfvars` file with your own values. The `terraform.tfvars.example` file is provided as a template.

## Deployment

This Terraform module uses the [`hashicorp/aws`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs) provider - see the documentation for how to configure your AWS credentials.
