resource "template_file" "etcd_cloud_config" {
  template = "${file("${path.module}/templates/etcd-cloud-config.yml")}"

  vars {
    etcd_discovery_url = "${var.discovery_url}"
  }
}

resource "aws_instance" "etcd" {
  count = "${var.etcd_size}"
  ami = "${var.coreos_ami}"
  instance_type = "${var.etcd_instance_type}"
  subnet_id = "${element(var.private_subnets, count.index)}"

  root_block_device = {
    volume_type = "gp2"
    volume_size = 10
  }

  vpc_security_group_ids = [
    "${var.default_security_group}",
    "${aws_security_group.etcd_cluster.id}",
    "${aws_security_group.etcd.id}"
  ]

  key_name = "${var.env}-pinglist-deployer"

  tags = {
    OS = "${var.env}-pinglist-coreos"
    Name = "${var.env}-pinglist-etcd-${count.index}"
  }

  user_data = "${template_file.etcd_cloud_config.rendered}"
}
