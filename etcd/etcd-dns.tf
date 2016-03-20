resource "aws_route53_record" "etcd" {
   zone_id = "${var.dns_zone_id}"
   name = "${var.env}-etcd.${var.dns_zone_name}"
   type = "CNAME"
   ttl = "60"
   records = ["${aws_elb.etcd.dns_name}"]
}
