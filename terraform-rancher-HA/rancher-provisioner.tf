resource "null_resource" "rancher-userdata"{
	depends_on = ["aws_ecs_service.rancher-svc"]
	
	provisioner "local-exec"{
		command = " while [[ \"$(curl -s -o /dev/null -w ''%{http_code}'' ${var.rancher_endpoint})\" != \"200\" ]]; do sleep 3 && echo Rancher is Setting Up; done "
		interpreter = ["/bin/bash", "-c"]
	 
	}
	provisioner "local-exec"{
		command = "export RANCHER_URL=${var.rancher_endpoint} && export env=${var.rancher_env} && task-definitions/scripts.sh "
	}
}


