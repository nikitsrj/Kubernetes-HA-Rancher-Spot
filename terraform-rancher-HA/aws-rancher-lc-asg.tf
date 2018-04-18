data "aws_availability_zones" "allzones" {}
data "aws_subnet_ids" "vpc" {
  vpc_id = "${var.vpc_id}"
}

resource "aws_elb" "Rancher-ECS-LB" {
  depends_on = ["aws_ecs_cluster.rancher-ecs"]
  name               = "${var.rancher_elb}"
  subnets             = ["${data.aws_subnet_ids.vpc.ids}"]
  security_groups = ["${var.security_group}"]
  listener {
    instance_port     = 80
    instance_protocol = "tcp"
    lb_port           = 443
    lb_protocol       = "ssl"
    ssl_certificate_id = "arn:aws:acm:us-east-1:230367374156:certificate/d001145a-b5fd-455d-b76c-dafcc79be381"
  }
    listener {
    instance_port     = 80
    instance_protocol = "tcp"
    lb_port           = 80
    lb_protocol       = "tcp"
  }

}

resource "aws_route53_record" "rancher-endpoint" {
  depends_on = ["aws_elb.Rancher-ECS-LB"]
  zone_id = "${var.zone_id}"
  name = "${var.rancher_dns}"
  type = "CNAME"
  ttl = "300"
  records = ["${aws_elb.Rancher-ECS-LB.dns_name}"]
}

resource "aws_proxy_protocol_policy" "websockets" {
  load_balancer  = "${aws_elb.Rancher-ECS-LB.name}"
  instance_ports = ["80"]
}

resource "aws_launch_configuration" "rancher-ecs-ha" {
    depends_on = ["aws_elb.Rancher-ECS-LB"]
    name = "${var.ecs_cluster_name}-LC"
    image_id = "${var.ami}"
    instance_type = "${var.rancher_instance_type}"
    key_name = "${var.key_name}"
    security_groups = ["${var.security_group}"]
    associate_public_ip_address = "true"
    iam_instance_profile = "${var.iam_instance_profile}"
    user_data = "#!/bin/bash \n sudo echo ECS_CLUSTER='${var.ecs_cluster_name}' > /etc/ecs/ecs.config \n sudo docker run --name ecs-agent --detach=true --restart=on-failure:10 --volume=/var/run:/var/run --volume=/var/log/ecs/:/log --volume=/var/lib/ecs/data:/data --volume=/etc/ecs:/etc/ecs --net=host --env-file=/etc/ecs/ecs.config amazon/amazon-ecs-agent:latest "
    lifecycle {
    create_before_destroy = true
  }
}


resource "aws_autoscaling_group" "rancher-ecs-asg" {
  depends_on = ["aws_elb.Rancher-ECS-LB"]
  name                 = "${var.ecs_asg}"
  launch_configuration = "${aws_launch_configuration.rancher-ecs-ha.name}"
  vpc_zone_identifier = ["${data.aws_subnet_ids.vpc.ids}"]
  load_balancers      = ["${aws_elb.Rancher-ECS-LB.name}"]
  min_size             = 2
  max_size             = 4

  lifecycle {
    create_before_destroy = true
  }
  tag {
    key                 = "Name"
    value               = "Rancher-ECS-APP"
    propagate_at_launch = true
  }
}





