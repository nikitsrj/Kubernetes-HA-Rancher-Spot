resource "aws_ecs_cluster" "rancher-ecs" {
  name = "${var.ecs_cluster_name}"
}

