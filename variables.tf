variable "env" {
  description = "Environment name"
}

variable "etcd_discovery_url" {
  description = "ETCD discovery URL"
}

variable "api_release" {
  description = "Release version of API service"
}

variable "db_password" {
  description = "Database password, provide through your ENV variables"
}

variable "etcd_size" {
  description = "ETCD cluster size"
  default = 1
}

variable "etcd_instance_type" {
  description = "EC2 instance type to use for ETCD nodes"
  default = "t2.micro"
}

variable "rds_instance_type" {
  description = "RDS instance type"
  default = "db.t1.micro"
}

variable "rds_allocated_storage" {
  description = "RDS allocated storage"
  default = 10
}

variable "rds_skip_final_snapshot" {
  description = "Determines whether a final snapshot is created before the instance is deleted"
  default = false
}

variable "api_min_size" {
  description = "API autoscaling group min size"
  default = 1
}

variable "api_max_size" {
  description = "API autoscaling group max size"
  default = 4
}

variable "api_instance_type" {
  description = "EC2 instance type to use for API nodes"
  default = "t2.micro"
}

variable "region"     {
  description = "AWS region"
  default = "eu-west-2"
}

variable "ubuntu_amis" {
  description = "Ubuntu 14.04 LTS AMIs by region"
  default = {
    eu-central-1 = "ami-7e9b7c11"
    ap-northeast-1 = "ami-01ded66f"
    sa-east-1 = "ami-cd53dea1"
    ap-southeast-2 = "ami-8fda11ec" # did not found this so using the one from ap-southeast-1
    ap-southeast-1 = "ami-8fda11ec"
    us-east-1 = "ami-df0607b5"
    us-west-2 = "ami-12394b72" # did not found this so using the one from us-west-1
    us-west-1 = "ami-12394b72"
    eu-west-1 = "ami-58cc762b"
  }
}

variable "coreos_amis" {
  description = "CoreOS AMIs by region"
  default = {
    eu-central-1 = "ami-15190379"
    ap-northeast-1 = "ami-02c9c86c"
    sa-east-1 = "ami-c40784a8"
    ap-southeast-2 = "ami-949abdf7"
    ap-southeast-1 = "ami-00a06963"
    us-east-1 = "ami-7f3a0b15"
    us-west-2 = "ami-4f00e32f"
    us-west-1 = "ami-a8aedfc8"
    eu-west-1 = "ami-2a1fad59"
  }
}

variable "ssl_certificate_id" {
  description = "The id of an SSL certificate uploaded to AWS IAM"
  default = "TODO"
}

variable "dns_zone_id" {
  description = "Amazon Route53 DNS zone identifier"
  default = "Z2J1YQ9IVK9WFX"
}

variable "dns_zone_name" {
  description = "Amazon Route53 DNS zone name"
  default     = "pingli.st"
}

variable "force_destroy" {
  description = "Delete S3 buckets content"
  default     = false
}
