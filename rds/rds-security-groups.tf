resource "aws_security_group" "rds_user" {
  name = "${var.env}-pinglist-rds-user-sg"
  description = "Security group for instances that want to connect to RDS"
  vpc_id = "${var.vpc_id}"

  tags = {
    Name = "${var.env}-pinglist-rds-user-sg"
  }
}

resource "aws_security_group" "rds" {
  name = "${var.env}-pinglist-rds-sg"
  description = "Security group for RDS instances that allows traffic from API servers"
  vpc_id = "${var.vpc_id}"

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [
      "${aws_security_group.rds_user.id}",
    ]
  }

  tags = {
    Name = "${var.env}-pinglist-rds-sg"
  }
}
