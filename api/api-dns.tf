resource "aws_route53_record" "api" {
  zone_id = "${var.dns_zone_id}"
  name = "${var.env}-api.${var.dns_zone_name}"
  type = "CNAME"
  ttl = "60"
  records = ["${aws_elb.api.dns_name}"]
}
