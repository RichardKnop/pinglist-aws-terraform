module "vpc" {
  source = "./vpc"

  env = "${var.env}"
  region = "${var.region}"
  ubuntu_ami = "${lookup(var.ubuntu_amis, var.region)}"
  dns_zone_id = "${var.dns_zone_id}"
  dns_zone_name = "${var.dns_zone_name}"
}

module "rds" {
  source = "./rds"

  env = "${var.env}"
  vpc_id = "${module.vpc.vpc_id}"
  rds_instance_type = "${var.rds_instance_type}"
  rds_allocated_storage = "${var.rds_allocated_storage}"
  rds_skip_final_snapshot = "${var.rds_skip_final_snapshot}"
  private_subnets = "${split(",", module.vpc.private_subnets)}"
  dns_zone_id = "${var.dns_zone_id}"
  dns_zone_name = "${var.dns_zone_name}"
  db_password = "${var.db_password}"
}

module "etcd" {
  source = "./etcd"

  env = "${var.env}"
  vpc_id = "${module.vpc.vpc_id}"
  etcd_size = "${var.etcd_size}"
  etcd_instance_type = "${var.etcd_instance_type}"
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
  api_min_size = "${var.api_min_size}"
  api_max_size = "${var.api_max_size}"
  api_instance_type = "${var.api_instance_type}"
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
