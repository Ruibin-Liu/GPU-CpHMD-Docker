##################
# The instance is preloaded with nvidia-384 driver and cuda9.0, and is 
# running on Ubuntu 16.04 Server LTS. In order to compile a suitable
# version of pmemd.cuda and pmemd.MPI for it, we need to prepare the environment 
# according to http://ambermd.org/InstUbuntu.php. Note that we also
# prepare the Docker images with cuda-9.0-runtime to be compatable.
##################

# Below is for compiling pmemd.cuda and pmemd.MPI
# If running Docker, it's not necessary. However, we need to have some of them
# during making the Docker image, i.e. fftw3-dev, gcc, gfortran, mpich, openssh-client
sudo apt-get update
sudo apt-get upgrade
apt -y install tcsh make fftw3-dev \
               gcc gfortran \
               flex bison patch \
               bc xorg-dev libbz2-dev wget \
               mpich openmpi-bin libopenmpi-dev openssh-client

# should work for ubuntu 16.04 LTS and 18.04 LTS
export DEBIAN_FRONTEND=noninteractive
sudo apt update
wget https://developer.nvidia.com/compute/cuda/10.0/Prod/local_installers/cuda_10.0.130_410.48_linux
sudo bash cuda_10.0.130_410.48_linux
cat << EOF >> ~/.bashrc
# set PATH for cuda 10.0 installation
if [ -d "/usr/local/cuda-10.0/bin/" ]; then
    export PATH=/usr/local/cuda-10.0/bin${PATH:+:${PATH}}
    export LD_LIBRARY_PATH=/usr/local/cuda-10.0/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
fi
EOF

# For ruuning Docker
sudo apt-get update
sudo apt-get upgrade
sudo apt install python-pip apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $DIST stable" 
sudo apt update
sudo apt install docker-ce
sudo usermod -aG docker $USER  && newgrp docker # add user to the docker grou
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
sudo apt-get update && sudo apt-get install -y nvidia-container-toolkit nvidia-docker2
sudo systemctl restart docker
pip install docker-compose
sudo cp /etc/docker/daemon.json /etc/docker/backup_daemon.json
sudo cp sample_daemon.json /etc/docker/daemon.json
echo 'The original /etc/docker/daemon.json file is backed up as /etc/docker/backup_daemon.json'
sudo pkill -SIGHUP dockerd