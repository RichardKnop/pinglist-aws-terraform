resource "aws_instance" "nat" {
  ami = "${var.ubuntu_ami}"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.public.0.id}"
  source_dest_check = false

  root_block_device = {
    volume_type = "gp2"
    volume_size = 10
  }

  security_groups = [
    "${aws_security_group.nat.id}",
    "${aws_security_group.nat_route.id}"
  ]

  key_name = "${var.env}-pinglist-deployer"
  connection {
    user = "ubuntu"
    key_file = "~/.ssh/${var.env}-pinglist-deployer"
  }

  provisioner "remote-exec" {
    script = "${path.module}/setup-nat-routing.sh"
  }

  tags = {
    OS = "${var.env}-pinglist-ubuntu"
    Name = "${var.env}-pinglist-nat"
  }
}

resource "aws_security_group" "nat" {
  name = "${var.env}-pinglist-nat-sg"
  description = "Security group for NAT instances that allows SSH from whitelisted IPs from internet"
  vpc_id = "${aws_vpc.default.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.env}-pinglist-nat-sg"
  }
}

resource "aws_security_group" "nat_route" {
  name = "${var.env}-pinglist-nat-route-sg"
  description = "Security group for nat instances that allows routing VPC traffic to internet"
  vpc_id = "${aws_vpc.default.id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    security_groups = [
      "${aws_security_group.default.id}"
    ]
  }

  tags {
    Name = "${var.env}-pinglist-nat-route-sg"
  }
}
