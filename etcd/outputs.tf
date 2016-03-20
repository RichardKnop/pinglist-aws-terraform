output "user_security_group" {
  value = "${aws_security_group.etcd_user.id}"
}

output "dns_name" {
  value = "${aws_route53_record.etcd.name}"
}
