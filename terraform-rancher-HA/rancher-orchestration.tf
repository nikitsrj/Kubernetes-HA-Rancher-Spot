resource "aws_launch_configuration" "rancher-orchestration" {
    depends_on = ["aws_launch_configuration.rancher-etcd"]
    name = "${var.rancher_orchestration}-LC"
    image_id = "${var.k8s_ami}"
    instance_type = "${var.orchestration_instance_type}"
    key_name = "${var.key_name}"
    security_groups = ["${var.security_group}"]
    associate_public_ip_address = "true"
    iam_instance_profile = "${var.iam_instance_profile}"
    user_data = "${file("orchestration-userdata.tpl")}"
    lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "rancher-orchestration-asg" {
  depends_on = ["aws_launch_configuration.rancher-orchestration"]
  name                 = "${var.orchestration_asg}"
  launch_configuration = "${aws_launch_configuration.rancher-orchestration.name}"
  vpc_zone_identifier = ["${data.aws_subnet_ids.vpc.ids}"]
  min_size             = 2
  max_size             = 4
  lifecycle {
    create_before_destroy = true
  }
   tag {
    key                 = "Name"
    value               = "rancher-orchestration"
    propagate_at_launch = true
  }
}
