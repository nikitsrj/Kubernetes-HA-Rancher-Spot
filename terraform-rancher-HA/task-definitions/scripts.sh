#!/bin/bash

TEMPLATE_ID=`rancher env template import task-definitions/kubetemplate`

PROJECT_ID=`rancher env create -t $TEMPLATE_ID $env`

sleep 5

curl -s -X POST ''$RANCHER_URL'/v1/registrationtokens?projectId='$PROJECT_ID''

TOKEN=`curl -H "Accept: application/json" -H "Content-Type: application/json" ''$RANCHER_URL'/v1/registrationtokens?projectId='$PROJECT_ID'' | jq -r '.data[0].token'`

DOCKERIMAGE=`curl -H "Accept: application/json" -H "Content-Type: application/json" ''$RANCHER_URL'/v1/registrationtokens?projectId='$PROJECT_ID'' | jq -r '.data[0].image'`

echo $TOKEN

echo $DOCKERIMAGE

touch etcd-userdata.tpl && cat <<EOF > etcd-userdata.tpl
#!/bin/bash

# install suported docker version for rancher-agent 
# http://rancher.com/docs/rancher/v1.6/en/hosts/#supported-docker versions

sudo curl https://releases.rancher.com/install-docker/17.03.sh | sh
sudo usermod -a -G docker ubuntu
sudo docker run -e CATTLE_HOST_LABELS='etcd=true' --rm --privileged -v /var/run/docker.sock:/var/run/docker.sock -v /var/lib/rancher:/var/lib/rancher $DOCKERIMAGE $RANCHER_URL/v1/scripts/$TOKEN

EOF

touch orchestration-userdata.tpl && cat <<EOF > orchestration-userdata.tpl
#!/bin/bash

# install suported docker version for rancher-agent 
# http://rancher.com/docs/rancher/v1.6/en/hosts/#supported-docker versions

sudo curl https://releases.rancher.com/install-docker/17.03.sh | sh
sudo usermod -a -G docker ubuntu
sudo docker run -e CATTLE_HOST_LABELS='orchestration=true' --rm --privileged -v /var/run/docker.sock:/var/run/docker.sock -v /var/lib/rancher:/var/lib/rancher $DOCKERIMAGE $RANCHER_URL/v1/scripts/$TOKEN

EOF

touch compute-userdata.tpl && cat <<EOF > compute-userdata.tpl
#!/bin/bash

# install suported docker version for rancher-agent 
# http://rancher.com/docs/rancher/v1.6/en/hosts/#supported-docker versions

sudo curl https://releases.rancher.com/install-docker/17.03.sh | sh
sudo usermod -a -G docker ubuntu
sudo docker run -e CATTLE_HOST_LABELS='compute=true' --rm --privileged -v /var/run/docker.sock:/var/run/docker.sock -v /var/lib/rancher:/var/lib/rancher $DOCKERIMAGE $RANCHER_URL/v1/scripts/$TOKEN

EOF
