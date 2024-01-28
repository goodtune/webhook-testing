variable "name" {
  description = "The name of the project"
  default     = "webhook-testing"
}

variable "environment" {
  description = "The environment to deploy to"
  default     = "dev"
}

variable "region" {
  description = "The region to deploy to"
  default     = "ap-southeast-2"
}

variable "secret" {
  description = "The secret to use for the webhook"
  sensitive   = true
}

variable "consumers" {
  description = "The list of consumers to create queues for"
  type        = set(string)
}
