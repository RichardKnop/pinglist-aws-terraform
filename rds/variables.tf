variable "env" {
  type        = "string"
  description = "Environment name"
}

variable "vpc_id" {
  type        = "string"
  description = "VPC ID"
}

variable "rds_instance_type" {
  type        = "string"
  description = "RDS instance type"
}

variable "rds_allocated_storage" {
  type        = "string"
  description = "RDS allocated storage"
}

variable "rds_skip_final_snapshot" {
  type        = "string"
  description = "Determines whether a final snapshot is created before the instance is deleted"
}

variable "private_subnets" {
  type        = "string"
  description = "Private subnets"
}

variable "dns_zone_id" {
  type        = "string"
  description = "Amazon Route53 DNS zone identifier"
}

variable "dns_zone_name" {
  type        = "string"
  description = "Amazon Route53 DNS zone name"
}

variable "postgres_engine_version" {
  type        = "string"
  description = "Version of Postgres we want to provision"
  default     = "9.5.2"
}

variable "db_username" {
  type        = "string"
  description = "Main database username"
  default     = "pinglist"
}

variable "db_password" {
  type        = "string"
  description = "Main database password"
}

variable "db_name" {
  type        = "string"
  description = "Main database name"
  default     = "pinglist"
}

variable "app_db_username" {
  type        = "string"
  description = "Web app's database username"
  default     = "pinglist_app"
}

variable "app_db_password" {
  type        = "string"
  description = "Web app's database password"
}

variable "app_db_name" {
  type        = "string"
  description = "Web app's database name"
  default     = "pinglist_app"
}
