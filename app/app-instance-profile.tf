resource "template_file" "app_assume_role_policy" {
  template = "${file("${path.module}/templates/app-assume-role-policy.json")}"
}

resource "aws_iam_role" "app" {
  name = "${var.env}-app-iam-role"
  assume_role_policy = "${template_file.app_assume_role_policy.rendered}"
}

resource "aws_iam_instance_profile" "app" {
  name = "${var.env}-app-iam-profile"
  roles = ["${aws_iam_role.app.name}"]
}
