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

variable "api_prefix" {
  type        = "string"
  description = "DNS prefix"
}

variable "apns_platform_application_arn" {
  type        = "string"
  description = "The id of a APNS platform application ARN"
}

variable "api_min_size" {
  type        = "string"
  description = "API autoscaling group min size"
}

variable "api_max_size" {
  type        = "string"
  description = "API autoscaling group max size"
}

variable "api_instance_type" {
  type        = "string"
  description = "EC2 instance type to use for API nodes"
}

variable "private_subnets" {
  type        = "string"
  description = "Private subnets"
}

variable "public_subnets" {
  type        = "string"
  description = "Public subnets"
}

variable "coreos_ami" {
  type        = "string"
  description = "CoreOS AMI for ETCD instances"
}

variable "default_security_group" {
  type        = "string"
  description = "Default security group"
}

variable "web_security_group" {
  type        = "string"
  description = "Web security group"
}

variable "etcd_user_security_group" {
  type        = "string"
  description = "ETCD user security group"
}

variable "rds_user_security_group" {
  type        = "string"
  description = "RDS user security group"
}

variable "ssl_certificate_id" {
  type        = "string"
  description = "The id of an SSL certificate uploaded to AWS IAM"
}

variable "api_release" {
  type        = "string"
  description = "Release version of API service"
}

variable "etcd_host" {
  type        = "string"
  description = "ETCD cluster hostname"
}

variable "dns_zone_id" {
  type        = "string"
  description = "Amazon Route53 DNS zone identifier"
}

variable "dns_zone_name" {
  type        = "string"
  description = "Amazon Route53 DNS zone name"
}

variable "release_bucket" {
  type        = "string"
  description = "S3 bucket to store release builds"
  default     = "pinglist.releases"
}
