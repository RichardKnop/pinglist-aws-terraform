resource "aws_elb" "api" {
  name = "${var.env}-pinglist-api-elb"
  subnets = ["${var.public_subnets}"]
  security_groups = [
    "${var.web_security_group}",
  ]

  listener {
    instance_port = 80
    instance_protocol = "http"
    lb_port = 443
    lb_protocol = "https"
    ssl_certificate_id = "${var.ssl_certificate_id}"
  }

  listener {
    instance_port = 80
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    target = "HTTP:80/v1/health"
    interval = 30
  }

  tags {
    Name = "${var.env}-pinglist-api-elb"
  }
}
