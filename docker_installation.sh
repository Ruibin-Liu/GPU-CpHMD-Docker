# /bin/bash

# system info
DIST=$(lsb_release -c |awk '{print $NF}')  
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
iTitrate_docker="`dirname \"$0\"`"                    # this script
iTitrate_docker="`( cd \"$iTitrate_docker\" && pwd )`"   # iTitrate package directory

# update driver for ubuntu 16.04 instance types.
if [ "$distribution" == "ubuntu16.04" ]; then
    /bin/bash $iTitrate_docker/update_driver.sh
fi

# for docker, docker-compose, and awscli
sudo apt update && sudo apt install -y python-pip apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $DIST stable"
sudo apt update && sudo apt install -y docker-ce
sudo systemctl enable docker
sudo -H pip install docker-compose awscli

# for nvidia-docker
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
sudo apt-get update && sudo apt-get install -y nvidia-container-toolkit nvidia-container-runtime
sudo mkdir -p /etc/systemd/system/docker.service.d
sudo tee /etc/systemd/system/docker.service.d/override.conf <<EOF
[Service]
ExecStart=
ExecStart=/usr/bin/dockerd --host=fd:// --add-runtime=nvidia=/usr/bin/nvidia-container-runtime
EOF
sudo systemctl daemon-reload
sudo systemctl restart docker

# change /etc/docker/daemon.json
sudo cp /etc/docker/daemon.json /etc/docker/backup_daemon.json
sudo cp $iTitrate_docker/sample_daemon.json /etc/docker/daemon.json
echo 'The original /etc/docker/daemon.json file is backed up as /etc/docker/backup_daemon.json'
sudo pkill -SIGHUP dockerd

# add user to the docker group
sudo usermod -aG docker $(whoami)  && newgrp docker
