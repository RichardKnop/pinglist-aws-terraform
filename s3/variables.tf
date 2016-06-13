variable "env" {
  type        = "string"
  description = "Environment name"
}

variable "region" {
  type        = "string"
  description = "AWS region"
}

variable "vpc_id" {
  type        = "string"
  description = "VPC ID"
}

variable "api_iam_role_arn" {
  type        = "string"
  description = "API IAM role ARN"
}

variable "app_iam_role_arn" {
  type        = "string"
  description = "Web app IAM role ARN"
}

variable "private_route_table" {
  type        = "string"
  description = "Private route table"
}

variable "force_destroy" {
  type        = "string"
  description = "Delete S3 buckets content"
}
