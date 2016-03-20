resource "aws_security_group" "api" {
  name = "${var.env}-pinglist-api-sg"
  description = "Security group for API instances that allows traffic from the ELB"
  vpc_id = "${var.vpc_id}"

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [
      "${var.web_security_group}",
    ]
  }

  tags = {
    Name = "${var.env}-pinglist-api-sg"
  }
}
