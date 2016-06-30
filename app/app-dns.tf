resource "aws_route53_record" "app" {
  zone_id = "${var.dns_zone_id}"
  name = "${var.app_prefix}${var.dns_zone_name}"
  type = "A"

  alias {
    zone_id = "${aws_elb.app.zone_id}"
    name = "${aws_elb.app.dns_name}"
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "app_www" {
  zone_id = "${var.dns_zone_id}"
  name = "www.${var.app_prefix}${var.dns_zone_name}"
  type = "A"

  alias {
    zone_id = "${aws_elb.app.zone_id}"
    name = "${aws_elb.app.dns_name}"
    evaluate_target_health = true
  }
}
