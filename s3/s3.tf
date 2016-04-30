resource "template_file" "private_s3_policy" {
  template = "${file("${path.module}/templates/s3-private-policy.json")}"
}

resource "aws_vpc_endpoint" "private_s3" {
  vpc_id = "${var.vpc_id}"
  service_name = "com.amazonaws.${var.region}.s3"
  policy = "${template_file.private_s3_policy.rendered}"
  route_table_ids = ["${var.private_route_table}"]
}

resource "template_file" "s3_assets_bucket_policy" {
  template = "${file("${path.module}/templates/s3-assets-bucket-policy.json")}"

  vars {
    env = "${var.env}"
  }
}

resource "aws_s3_bucket" "assets" {
  bucket = "${var.env}.pinglist.assets"
  acl = "private"
  force_destroy = "${var.force_destroy}"
  policy = "${template_file.s3_assets_bucket_policy.rendered}"

  tags {
    Name = "S3 bucket for assets"
    Environment = "${var.env}"
  }
}
