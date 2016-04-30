module "vpc" {
  source = "./vpc"

  env = "${var.env}"
  region = "${var.region}"
  nat_ami = "${lookup(var.nat_amis, var.region)}"
  dns_zone_id = "${var.dns_zone_id}"
  dns_zone_name = "${var.dns_zone_name}"
  nat_instance_type = "${lookup(var.nat_instance_type, var.env)}"
}

module "rds" {
  source = "./rds"

  env = "${var.env}"
  vpc_id = "${module.vpc.vpc_id}"
  rds_instance_type = "${lookup(var.rds_instance_type, var.env)}"
  rds_allocated_storage = "${lookup(var.rds_allocated_storage, var.env)}"
  rds_skip_final_snapshot = "${var.rds_skip_final_snapshot}"
  private_subnets = "${split(",", module.vpc.private_subnets)}"
  dns_zone_id = "${var.dns_zone_id}"
  dns_zone_name = "${var.dns_zone_name}"
  db_password = "${var.db_password}"
  app_db_password = "${var.app_db_password}"
}

module "etcd" {
  source = "./etcd"

  env = "${var.env}"
  vpc_id = "${module.vpc.vpc_id}"
  etcd_size = "${lookup(var.etcd_size, var.env)}"
  etcd_instance_type = "${lookup(var.etcd_instance_type, var.env)}"
  private_subnets = "${split(",", module.vpc.private_subnets)}"
  coreos_ami = "${lookup(var.coreos_amis, var.region)}"
  default_security_group = "${module.vpc.default_security_group}"
  discovery_url = "${var.etcd_discovery_url}"
  dns_zone_id = "${var.dns_zone_id}"
  dns_zone_name = "${var.dns_zone_name}"
}

module "api" {
  source = "./api"

  env = "${var.env}"
  region = "${var.region}"
  vpc_id = "${module.vpc.vpc_id}"
  api_prefix = "${lookup(var.api_prefix, var.env)}"
  api_min_size = "${lookup(var.api_min_size, var.env)}"
  api_max_size = "${lookup(var.api_max_size, var.env)}"
  api_instance_type = "${lookup(var.api_instance_type, var.env)}"
  private_subnets = "${split(",", module.vpc.private_subnets)}"
  public_subnets = "${split(",", module.vpc.public_subnets)}"
  coreos_ami = "${lookup(var.coreos_amis, var.region)}"
  default_security_group = "${module.vpc.default_security_group}"
  web_security_group = "${module.vpc.web_security_group}"
  etcd_user_security_group = "${module.etcd.user_security_group}"
  rds_user_security_group = "${module.rds.user_security_group}"
  ssl_certificate_id = "${var.ssl_certificate_id}"
  api_release = "${var.api_release}"
  etcd_host = "${module.etcd.dns_name}"
  dns_zone_id = "${var.dns_zone_id}"
  dns_zone_name = "${var.dns_zone_name}"
}

module "s3" {
  source = "./s3"

  env = "${var.env}"
  region = "${var.region}"
  vpc_id = "${module.vpc.vpc_id}"
  private_route_table = "${module.vpc.private_route_table}"
  force_destroy = "${var.force_destroy}"
}

module "app" {
  source = "./app"

  env = "${var.env}"
  region = "${var.region}"
  vpc_id = "${module.vpc.vpc_id}"
  app_prefix = "${lookup(var.app_prefix, var.env)}"
  app_min_size = "${lookup(var.app_min_size, var.env)}"
  app_max_size = "${lookup(var.app_max_size, var.env)}"
  app_instance_type = "${lookup(var.app_instance_type, var.env)}"
  private_subnets = "${split(",", module.vpc.private_subnets)}"
  public_subnets = "${split(",", module.vpc.public_subnets)}"
  coreos_ami = "${lookup(var.coreos_amis, var.region)}"
  default_security_group = "${module.vpc.default_security_group}"
  web_security_group = "${module.vpc.web_security_group}"
  etcd_user_security_group = "${module.etcd.user_security_group}"
  rds_user_security_group = "${module.rds.user_security_group}"
  ssl_certificate_id = "${var.ssl_certificate_id}"
  app_release = "${var.app_release}"
  etcd_host = "${module.etcd.dns_name}"
  dns_zone_id = "${var.dns_zone_id}"
  dns_zone_name = "${var.dns_zone_name}"
}
