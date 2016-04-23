variable "env" {
  type        = "string"
  description = "Environment name"
}

variable "nat_instance_type" {
  type        = "map"
  description = "EC2 instance type to use for NAT server"

  default     = {
    stage = "t2.nano"
    prod  = "t2.nano"
  }
}

variable "etcd_discovery_url" {
  type        = "string"
  description = "ETCD discovery URL"
}

variable "api_release" {
  type        = "string"
  description = "Release version of API service"
}

variable "db_password" {
  type        = "string"
  description = "Database password, provide through your ENV variables"
}

variable "etcd_size" {
  type        = "map"
  description = "ETCD cluster size"

  default     = {
    stage = 1
    prod  = 1
  }
}

variable "etcd_instance_type" {
  type        = "map"
  description = "EC2 instance type to use for ETCD nodes"

  default     = {
    stage = "t2.nano"
    prod  = "t2.nano"
  }
}

variable "rds_instance_type" {
  type        = "map"
  description = "RDS instance type"

  default     = {
    stage = "db.t2.micro"
    prod  = "db.t2.small"
  }
}

variable "rds_allocated_storage" {
  type        = "map"
  description = "RDS allocated storage"

  default     = {
    stage = 10
    prod  = 30
  }
}

variable "rds_skip_final_snapshot" {
  type        = "string"
  description = "Determines whether a final snapshot is created before the instance is deleted"
  default     = false
}

variable "api_min_size" {
  type        = "map"
  description = "API autoscaling group min size"

  default     = {
    stage = 1
    prod  = 1
  }
}

variable "api_max_size" {
  type        = "map"
  description = "API autoscaling group max size"

  default     = {
    stage = 4
    prod  = 4
  }
}

variable "api_instance_type" {
  type        = "map"
  description = "EC2 instance type to use for API nodes"

  default     = {
    stage = "t2.micro"
    prod  = "t2.micro"
  }
}

variable "region" {
  type        = "string"
  description = "AWS region"
  default     = "us-west-2"
}

variable "ubuntu_amis" {
  type        = "map"
  description = "Ubuntu 14.04 LTS AMIs by region"

  default     = {
    us-west-2 = "ami-eb49bc8b"
  }
}

variable "coreos_amis" {
  type        = "map"
  description = "CoreOS AMIs by region"

  default     = {
    us-west-2 = "ami-4f7f8a2f"
  }
}

variable "ssl_certificate_id" {
  type        = "string"
  description = "The id of an SSL certificate uploaded to AWS IAM"
  default     = "arn:aws:iam::800222191807:server-certificate/pinglist-certificate"
}

variable "dns_zone_id" {
  type        = "string"
  description = "Amazon Route53 DNS zone identifier"
  default     = "Z3MMAQ2RD2LDLA"
}

variable "dns_zone_name" {
  type        = "string"
  description = "Amazon Route53 DNS zone name"
  default     = "pingli.st"
}

variable "api_prefix" {
  type        = "map"
  description = "Prefix for API based on environment"

  default     = {
    stage = "stage-api"
    prod  = "api"
  }
}

variable "force_destroy" {
  type        = "string"
  description = "Delete S3 buckets content"
  default     = false
}
