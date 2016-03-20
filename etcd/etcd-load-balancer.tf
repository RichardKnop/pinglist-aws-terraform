resource "aws_elb" "etcd" {
  name = "${var.env}-pinglist-etcd-elb"
  subnets = ["${var.private_subnets}"]
  internal = true
  security_groups = [
    "${aws_security_group.etcd_elb.id}",
  ]

  listener {
    instance_port = 2379
    instance_protocol = "http"
    lb_port = 2379
    lb_protocol = "http"
  }

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    target = "HTTP:2379/health"
    interval = 30
  }

  instances = ["${aws_instance.etcd.*.id}"]

  tags {
    Name = "${var.env}-pinglist-etcd-elb"
  }
}

resource "null_resource" "etcd_cluster" {
  # Changes to any instance of the cluster requires re-provisioning
  triggers {
    cluster_instance_ids = "${join(",", aws_instance.etcd.*.id)}"
  }

  provisioner "local-exec" {
    command = <<EOF
      (
        sleep 120s ; # Wait to make sure instance's SSH is up
        cd ${path.root}/ansible ;
        ./render-ssh-config.sh ${var.env} ;
        ansible-playbook -i ec2.py etcd.yml -e @aws.yml -e "deploy_env=${var.env}" -vvvv
      )
EOF
  }
}
