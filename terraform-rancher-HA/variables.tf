variable "ecs_cluster_name"{
  default = "Rancher-ECS-HA"
}
variable "ami"{
	default = "ami-88d136f5"
}
variable "rancher_instance_type"{
	default = "t2.micro"
}
variable "security_group"{
	default = "sg-cec3e6bc"
}
variable "key_name"{
	default = "devops-miq"
}
variable "iam_instance_profile"{
	default = "EC2-Dummy-Role"
}
variable "vpc_id"{
	default = "vpc-1499e871"
}
variable "rancher_elb"{
	default = "Rancher-ECS-LB"
}
variable "ecs_asg"{
	default = "rancher-ecs-asg"
}
variable "rancher_svc"{
	default = "rancher-svc"
}
variable "ecs_service_role"{
	default = "arn:aws:iam::230367374156:role/ecs-service-role"
}
variable "rancher_dns"{
    default = "rancher010614"
}
variable "zone_id"{
	default = "Z319QN2AZFYKW7"
}
variable "rancher_endpoint"{
	default = "http://rancher010614.mediaiqdigital.com"
}
variable "rancher_env"{
	default = "production"
}
variable "rancher_etcd"{
	default = "Rancher-etcd"
}
variable "k8s_ami"{
	default = "ami-da05a4a0"
}
variable "etcd_instance_type"{
	default = "t2.small"
}
variable "rancher_orchestration"{
	default = "Rancher-orchestration"
}
variable "orchestration_instance_type"{
	default = "t2.small"
}
variable "rancher_compute"{
	default = "Rancher-compute"
}
variable "compute_instance_type"{
	default = "t2.xlarge"
}
variable "etcd_asg"{
	default = "Rancher-etcd-asg"
}
variable "orchestration_asg"{
	default = "Rancher-orchestration-asg"
}
variable "compute_asg"{
	default = "Rancher-compute-asg"
}

