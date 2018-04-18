resource "aws_launch_configuration" "rancher-etcd" {
    depends_on = ["null_resource.rancher-userdata"]
    name = "${var.rancher_etcd}-LC"
    image_id = "${var.k8s_ami}"
    instance_type = "${var.etcd_instance_type}"
    key_name = "${var.key_name}"
    security_groups = ["${var.security_group}"]
    associate_public_ip_address = "true"
    iam_instance_profile = "${var.iam_instance_profile}"
    user_data = "${file("etcd-userdata.tpl")}"
    lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "rancher-etcd-asg" {
  depends_on = ["aws_launch_configuration.rancher-etcd"]
  name                 = "${var.etcd_asg}"
  launch_configuration = "${aws_launch_configuration.rancher-etcd.name}"
  vpc_zone_identifier = ["${data.aws_subnet_ids.vpc.ids}"]
  min_size             = 3
  max_size             = 4
  lifecycle {
    create_before_destroy = true
  }
   tag {
    key                 = "Name"
    value               = "Rancher-etcd"
    propagate_at_launch = true
  }
}



