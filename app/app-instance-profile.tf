resource "template_file" "app_assume_role_policy" {
  template = "${file("${path.module}/templates/app-assume-role-policy.json")}"
}

resource "aws_iam_role" "app" {
  name = "${var.env}-app-iam-role"
  assume_role_policy = "${template_file.app_assume_role_policy.rendered}"
}

resource "template_file" "app_s3_policy" {
  template = "${file("${path.module}/templates/app-s3-policy.json")}"
}

resource "aws_iam_role_policy" "s3" {
  name = "${var.env}-app-iam-role-s3-policy"
  role = "${aws_iam_role.app.id}"
  policy = "${template_file.app_s3_policy.rendered}"
}

resource "aws_iam_instance_profile" "app" {
  name = "${var.env}-app-iam-profile"
  roles = ["${aws_iam_role.app.name}"]
}
