resource "aws_db_instance" "rds" {
  identifier = "${var.env}-pinglist-rds"
  name = "${var.db_name}"
  allocated_storage = "${var.rds_allocated_storage}"
  storage_type = "gp2"
  skip_final_snapshot = "${var.rds_skip_final_snapshot}"
  engine = "postgres"
  engine_version = "${var.postgres_engine_version}"
  instance_class = "${var.rds_instance_type}"
  username = "${var.db_username}"
  password = "${var.db_password}"
  auto_minor_version_upgrade = true
  allow_major_version_upgrade = true
  vpc_security_group_ids = [
    "${aws_security_group.rds.id}",
  ]

  db_subnet_group_name = "${var.env}-pinglist-db-subnet-group"
  publicly_accessible = false
  backup_retention_period = 7
  depends_on = ["aws_db_subnet_group.default"]
}

resource "aws_db_subnet_group" "default" {
  name = "${var.env}-pinglist-db-subnet-group"
  description = "Our main group of subnets"
  subnet_ids = ["${var.private_subnets}"]
}

provider "postgresql" {
  host = "${aws_db_instance.rds.address}"
  username = "${var.db_username}"
  password = "${var.db_password}"
}

resource "postgresql_role" "app" {
  name = "${var.app_db_username}"
  login = true
  password = "${var.app_db_password}"
  depends_on = ["aws_db_instance.rds"]
}

resource "postgresql_database" "app" {
  name = "${var.app_db_name}"
  owner = "${postgresql_role.app.name}"
  depends_on = ["aws_db_instance.rds"]
}
