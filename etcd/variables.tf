variable "env" {
  description = "Environment name"
}

variable "vpc_id" {
  description = "VPC ID"
}

variable "etcd_size" {
  description = "ETCD cluster size"
}

variable "etcd_instance_type" {
  description = "EC2 instance type to use for ETCD nodes"
}

variable "private_subnets" {
  description = "Private subnets"
}

variable "coreos_ami" {
  description = "CoreOS AMI for ETCD instances"
}

variable "default_security_group" {
  description = "Default security group"
}

variable "discovery_url" {
  description = "ETCD discovery URL"
}

variable "dns_zone_id" {
  description = "Amazon Route53 DNS zone identifier"
}

variable "dns_zone_name" {
  description = "Amazon Route53 DNS zone name"
}
