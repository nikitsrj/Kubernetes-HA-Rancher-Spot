resource "aws_ecs_task_definition" "rancher-td" {
    family = "rancher-ecs-ha-td"
    depends_on = ["aws_autoscaling_group.rancher-ecs-asg"]
    container_definitions = "${file("task-definitions/rancher-td.json")}"
}
resource "aws_ecs_service" "rancher-svc" {
    name = "${var.rancher_svc}"
    depends_on = ["aws_ecs_task_definition.rancher-td"]
    cluster = "${var.ecs_cluster_name}"
    task_definition = "${aws_ecs_task_definition.rancher-td.arn}"
    iam_role = "${var.ecs_service_role}"
    desired_count = 1
    load_balancer {
        elb_name = "${aws_elb.Rancher-ECS-LB.name}"
        container_name = "rancher"
        container_port = 8080
    }
}

