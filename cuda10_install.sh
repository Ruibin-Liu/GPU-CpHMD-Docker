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