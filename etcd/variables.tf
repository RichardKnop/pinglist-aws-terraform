variable "env" {
  type        = "string"
  description = "Environment name"
}

variable "vpc_id" {
  type        = "string"
  description = "VPC ID"
}

variable "etcd_size" {
  type        = "string"
  description = "ETCD cluster size"
}

variable "etcd_instance_type" {
  type        = "string"
  description = "EC2 instance type to use for ETCD nodes"
}

variable "private_subnets" {
  type        = "string"
  description = "Private subnets"
}

variable "coreos_ami" {
  type        = "string"
  description = "CoreOS AMI for ETCD instances"
}

variable "default_security_group" {
  type        = "string"
  description = "Default security group"
}

variable "discovery_url" {
  type        = "string"
  description = "ETCD discovery URL"
}

variable "dns_zone_id" {
  type        = "string"
  description = "Amazon Route53 DNS zone identifier"
}

variable "dns_zone_name" {
  type        = "string"
  description = "Amazon Route53 DNS zone name"
}
