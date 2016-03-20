variable "env" {
  description = "Environment name"
}

variable "vpc_id" {
  description = "VPC ID"
}

variable "rds_instance_type" {
  description = "RDS instance type"
}

variable "rds_allocated_storage" {
  description = "RDS allocated storage"
}

variable "rds_skip_final_snapshot" {
  description = "Determines whether a final snapshot is created before the instance is deleted"
}

variable "private_subnets" {
  description = "Private subnets"
}

variable "dns_zone_id" {
  description = "Amazon Route53 DNS zone identifier"
}

variable "dns_zone_name" {
  description = "Amazon Route53 DNS zone name"
}

variable "postgres_engine_version" {
  description = "Version of Postgres we want to provision"
  default = "9.4.5"
}

variable "db_password" {
  description = "Database password"
}

variable "db_name" {
  description = "Database name"
  default = "pinglist"
}

variable "db_username" {
  description = "Database username"
  default = "pinglist"
}
