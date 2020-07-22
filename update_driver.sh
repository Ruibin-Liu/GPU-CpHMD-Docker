# /bin/bash

yes | sudo apt-get purge libcuda1-384
yes | sudo apt-get purge nvidia-384
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/cuda-repo-ubuntu1604_10.0.130-1_amd64.deb
sudo dpkg -i cuda-repo-ubuntu1604_10.0.130-1_amd64.deb
sudo apt-key adv --fetch-keys http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/7fa2af80.pub
sudo mkdir /usr/lib/nvidia
sudo apt-get update && yes | sudo apt-get install cuda-10-0