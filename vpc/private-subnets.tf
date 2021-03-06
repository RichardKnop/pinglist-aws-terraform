resource "aws_subnet" "private" {
  count = 3
  vpc_id = "${aws_vpc.default.id}"
  cidr_block = "${lookup(var.private_cidrs, concat("zone", count.index))}"
  availability_zone = "${lookup(var.availability_zones, concat("zone", count.index))}"
  map_public_ip_on_launch = false
  depends_on = ["aws_instance.nat"]
  tags {
    Name = "${var.env}-pinglist-private-subnet-${count.index}"
  }
}

resource "aws_route_table" "private" {
  vpc_id = "${aws_vpc.default.id}"
  route {
    cidr_block = "0.0.0.0/0"
    instance_id = "${aws_instance.nat.id}"
  }
}

resource "aws_route_table_association" "private" {
  count = 3
  subnet_id = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${aws_route_table.private.id}"
}
