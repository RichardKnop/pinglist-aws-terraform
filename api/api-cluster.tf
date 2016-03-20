resource "template_file" "api_cloud_config" {
  template = "${file("${path.module}/templates/api-cloud-config.yml")}"

  vars {
    iam_role = "${aws_iam_role.api.name}"
    bucket = "${var.release_bucket}"
    release = "${var.api_release}"
    region = "${var.region}"
    etcd_host = "${var.etcd_host}"
  }
}

resource "aws_launch_configuration" "api" {
  image_id = "${var.coreos_ami}"
  instance_type = "${var.api_instance_type}"
  iam_instance_profile = "${aws_iam_instance_profile.api.name}"

  root_block_device = {
    volume_type = "gp2"
    volume_size = 10
  }

  security_groups = [
    "${var.default_security_group}",
    "${aws_security_group.api.id}",
    "${var.etcd_user_security_group}",
    "${var.rds_user_security_group}",
  ]

  key_name = "${var.env}-pinglist-deployer"

  user_data = "${template_file.api_cloud_config.rendered}"
}

resource "aws_autoscaling_group" "api" {
  name = "${var.env}-pinglist-api-autoscaling-group"
  vpc_zone_identifier = ["${var.private_subnets}"]
  launch_configuration = "${aws_launch_configuration.api.name}"
  load_balancers = ["${aws_elb.api.name}"]

  min_size = "${var.api_min_size}"
  max_size = "${var.api_max_size}"
  desired_capacity = "${var.api_min_size}"

  tag {
    key = "OS"
    value = "${var.env}-pinglist-coreos"
    propagate_at_launch = true
  }

  tag {
    key = "Name"
    value = "${var.env}-pinglist-api"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "api_scale_up" {
  name = "${var.env}-pinglist-api-scale-up-policy"
  scaling_adjustment = 1
  adjustment_type = "ChangeInCapacity"
  cooldown = 300
  autoscaling_group_name = "${aws_autoscaling_group.api.name}"
}

resource "aws_cloudwatch_metric_alarm" "api_scale_up" {
  alarm_name = "${var.env}-pinglist-api-scale-up-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = "2"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "120"
  statistic = "Average"
  threshold = "80"
  dimensions {
    AutoScalingGroupName = "${aws_autoscaling_group.api.name}"
  }
  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions = ["${aws_autoscaling_policy.api_scale_up.arn}"]
}

resource "aws_autoscaling_policy" "api_scale_down" {
  name = "${var.env}-pinglist-api-scale-down-policy"
  scaling_adjustment = -1
  adjustment_type = "ChangeInCapacity"
  cooldown = 300
  autoscaling_group_name = "${aws_autoscaling_group.api.name}"
}

resource "aws_cloudwatch_metric_alarm" "api_scale_down" {
  alarm_name = "${var.env}-pinglist-api-scale-down-alarm"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods = "2"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "300"
  statistic = "Average"
  threshold = "40"
  dimensions {
    AutoScalingGroupName = "${aws_autoscaling_group.api.name}"
  }
  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions = ["${aws_autoscaling_policy.api_scale_down.arn}"]
}
