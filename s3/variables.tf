variable "env" {
  description = "Environment name"
}

variable "region" {
  description = "AWS region"
}

variable "vpc_id" {
  description = "VPC ID"
}

variable "private_route_table" {
  description = "Private route table"
}

variable "force_destroy" {
  description = "Delete S3 buckets content"
}
