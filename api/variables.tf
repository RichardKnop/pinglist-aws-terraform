variable "env" {
  description = "Environment name"
}

variable "region" {
  description = "AWS region"
}

variable "vpc_id" {
  description = "VPC ID"
}

variable "api_min_size" {
  description = "API autoscaling group min size"
}

variable "api_max_size" {
  description = "API autoscaling group max size"
}

variable "api_instance_type" {
  description = "EC2 instance type to use for API nodes"
}

variable "private_subnets" {
  description = "Private subnets"
}

variable "public_subnets" {
  description = "Public subnets"
}

variable "coreos_ami" {
  description = "CoreOS AMI for ETCD instances"
}

variable "default_security_group" {
  description = "Default security group"
}

variable "web_security_group" {
  description = "Web security group"
}

variable "etcd_user_security_group" {
  description = "ETCD user security group"
}

variable "rds_user_security_group" {
  description = "RDS user security group"
}

variable "ssl_certificate_id" {
  description = "The id of an SSL certificate uploaded to AWS IAM"
}

variable "api_release" {
  description = "Release version of API service"
}

variable "etcd_host" {
  description = "ETCD cluster hostname"
}

variable "dns_zone_id" {
  description = "Amazon Route53 DNS zone identifier"
}

variable "dns_zone_name" {
  description = "Amazon Route53 DNS zone name"
}

variable "release_bucket" {
  description = "S3 bucket to store release builds"
  default = "pinglist.releases"
}
