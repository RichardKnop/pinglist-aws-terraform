resource "aws_security_group" "etcd_user" {
  name = "${var.env}-pinglist-etcd-user-sg"
  description = "Security group for instances that want to connect to ETCD"
  vpc_id = "${var.vpc_id}"

  tags = {
    Name = "${var.env}-pinglist-etcd-user-sg"
  }
}

resource "aws_security_group" "etcd_elb" {
  name = "${var.env}-pinglist-etcd-elb-sg"
  description = "Security group for ETCD internal ELB that allows traffic from API servers"
  vpc_id = "${var.vpc_id}"

  ingress {
    from_port       = 2379
    to_port         = 2379
    protocol        = "tcp"
    security_groups = [
      "${aws_security_group.etcd_user.id}",
    ]
  }

  egress {
    from_port   = 2379
    to_port     = 2379
    protocol    = "tcp"
    security_groups = [
      "${var.default_security_group}",
    ]
  }

  tags = {
    Name = "${var.env}-pinglist-etcd-elb-sg"
  }
}


resource "aws_security_group" "etcd" {
  name = "${var.env}-pinglist-etcd-sg"
  description = "Security group for ETCD instances that allows client traffic from the ELB"
  vpc_id = "${var.vpc_id}"

  ingress {
    from_port       = 2379
    to_port         = 2379
    protocol        = "tcp"
    security_groups = [
      "${aws_security_group.etcd_elb.id}",
    ]
  }

  tags = {
    Name = "${var.env}-pinglist-etcd-sg"
  }
}

resource "aws_security_group" "etcd_cluster" {
  name = "${var.env}-pinglist-etcd-cluster-sg"
  description = "Security group for ETCD cluster that allows peer traffic between instances"
  vpc_id = "${var.vpc_id}"
  depends_on = ["aws_security_group.etcd"]

  ingress {
    from_port       = 2380
    to_port         = 2380
    protocol        = "tcp"
    security_groups = [
      "${aws_security_group.etcd.id}",
    ]
  }

  egress {
    from_port       = 2380
    to_port         = 2380
    protocol        = "tcp"
    security_groups = [
      "${aws_security_group.etcd.id}",
    ]
  }

  tags = {
    Name = "${var.env}-pinglist-etcd-cluster-sg"
  }
}
