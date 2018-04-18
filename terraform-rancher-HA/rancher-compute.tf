resource "aws_launch_configuration" "rancher-compute" {
    depends_on = ["aws_launch_configuration.rancher-orchestration"]
    name = "${var.rancher_compute}-LC"
    image_id = "${var.k8s_ami}"
    instance_type = "${var.compute_instance_type}"
    key_name = "${var.key_name}"
    security_groups = ["${var.security_group}"]
    associate_public_ip_address = "true"
    iam_instance_profile = "${var.iam_instance_profile}"
    user_data = "${file("compute-userdata.tpl")}"
    lifecycle {
    create_before_destroy = true
  }
}
resource "aws_autoscaling_group" "rancher-compute-asg" {
  depends_on = ["aws_launch_configuration.rancher-compute"]
  name                 = "${var.compute_asg}"
  launch_configuration = "${aws_launch_configuration.rancher-compute.name}"
  vpc_zone_identifier = ["${data.aws_subnet_ids.vpc.ids}"]
  min_size             = 2
  max_size             = 4
  lifecycle {
    create_before_destroy = true
  }
  tag {
    key                 = "Name"
    value               = "Rancher-Compute"
    propagate_at_launch = true
  }
}