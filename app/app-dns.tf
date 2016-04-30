resource "aws_route53_record" "app" {
  zone_id = "${var.dns_zone_id}"
  name = "${var.app_prefix}${var.dns_zone_name}"
  type = "CNAME"
  ttl = "60"
  records = ["${aws_elb.app.dns_name}"]
}
