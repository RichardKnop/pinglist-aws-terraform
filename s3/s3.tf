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
    vpc_id = "${var.vpc_id}"
    api_iam_role_arn = "${var.api_iam_role_arn}"
    app_iam_role_arn = "${var.app_iam_role_arn}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_s3_bucket" "assets" {
  bucket = "${var.env}.pinglist.assets"
  acl = "private"
  force_destroy = "${var.force_destroy}"
  policy = "${template_file.s3_assets_bucket_policy.rendered}"

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET"]
    allowed_origins = [
      "https://pingli.st",
      "https://www.pingli.st",
      "https://*.pingli.st",
      "https://www.*.pingli.st"
    ]
    expose_headers = ["ETag"]
    max_age_seconds = 3000
  }

  tags {
    Name = "S3 bucket for assets"
    Environment = "${var.env}"
  }

  lifecycle {
    create_before_destroy = true
  }
}
