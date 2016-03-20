resource "template_file" "api_assume_role_policy" {
  template = "${file("${path.module}/templates/api-assume-role-policy.json")}"
}

resource "aws_iam_role" "api" {
  name = "${var.env}-api-iam-role"
  assume_role_policy = "${template_file.api_assume_role_policy.rendered}"
}

resource "template_file" "api_s3_policy" {
  template = "${file("${path.module}/templates/api-s3-policy.json")}"
}

resource "aws_iam_role_policy" "s3" {
  name = "${var.env}-api-iam-role-s3-policy"
  role = "${aws_iam_role.api.id}"
  policy = "${template_file.api_s3_policy.rendered}"
}

resource "aws_iam_instance_profile" "api" {
  name = "${var.env}-api-iam-profile"
  roles = ["${aws_iam_role.api.name}"]
}
