#!/bin/bash

# install suported docker version for rancher-agent 
# http://rancher.com/docs/rancher/v1.6/en/hosts/#supported-docker versions

sudo curl https://releases.rancher.com/install-docker/17.03.sh | sh
sudo usermod -a -G docker ubuntu
sudo docker run -e CATTLE_HOST_LABELS='orchestration=true' --rm --privileged -v /var/run/docker.sock:/var/run/docker.sock -v /var/lib/rancher:/var/lib/rancher rancher/agent:v1.2.9 http://rancher010614.mediaiqdigital.com/v1/scripts/F603DD48E4A21B32E4DF:1514678400000:ZjGIXE8E0SIYz71goEnshxbvA

