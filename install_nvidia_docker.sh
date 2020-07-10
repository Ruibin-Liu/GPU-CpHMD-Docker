sudo systemctl restart docker
sudo systemctl enable docker
echo "Docker Detected!"
sudo apt-get update && sudo apt-get install -y nvidia-container-toolkit nvidia-container-runtime
sudo mkdir -p /etc/systemd/system/docker.service.d
sudo tee /etc/systemd/system/docker.service.d/override.conf <<EOF
[Service]
ExecStart=
ExecStart=/usr/bin/dockerd --host=fd:// --add-runtime=nvidia=/usr/bin/nvidia-container-runtime
EOF
sudo systemctl daemon-reload
sudo systemctl restart docker
sudo cp sample_daemon.json /etc/docker/daemon.json 
sudo pkill -SIGHUP dockerd
echo "Nvidia-docker installed!"
sudo -H pip install awscli docker-compose
