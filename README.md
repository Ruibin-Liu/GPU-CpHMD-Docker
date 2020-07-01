# iTitrate-Docker

iTitrate, developed by [ComputChem LLC](https://www.computchem.com/), is software created to accurately predict the pK<sub>a</sub>'s of titratable residues by simulating an acid-base titration experiment, i.e., letting a protein adjust its protonation and conformational states to solution pH, based on the GPU version of the Continuous Constant pH Molecular Dynamics (CpHMD) simulations in Amber software. It prepares CpHMD-ready PDB structures from protein crystal structures, stages CpHMD simulations, and generates pK<sub>a</sub> related results. Moreover, it provides a web GUI to control simulation parameters, monitor processes, and visualize results. Its Docker images privately stored on Amazon Web Services Elastic Container Registry (AWS ECR) which can run directly if `docker` and `docker-compose` are installed properly in your local machines with Nvidia GPU enabled. This repository, iTitrate-Docker, is for step-by-step instructions on how to use the Docker images.

## Step 0. Contact us

The Docker images are privately stored and only accessible with our permission. If you want to test or use our product, please contact us through our website [contact page](https://www.computchem.com/contact).

## Step 1. Install [docker](https://www.docker.com/)

### Required: A decent Nvidia GPU with the newest [nvidia driver](https://www.nvidia.com/Download/index.aspx?lang=en-us) and [cuda10.0](https://developer.nvidia.com/cuda-10.0-download-archive) installed; you can also `bash cuda10_install.sh` to install both the driver and cuda 10.0

- Install docker, docker-compose, and nvidia-docker by pasting the commands bellow on Docker supported [Ubuntu distributions](https://download.docker.com/linux/ubuntu/dists/). For other Linux distros, please adjust the commands accordingly.

```bash
# For docker
sudo apt update
sudo apt install python-pip apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"  # replace 'bionic' with other supported distributions listed on https://download.docker.com/linux/ubuntu/dists/.
sudo apt update
sudo apt install docker-ce
sudo usermod -aG docker $USER  && newgrp docker # add user to the docker group

# For nvidia-docker and docker-compose
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
sudo apt-get update && sudo apt-get install -y nvidia-container-toolkit nvidia-docker2
sudo systemctl restart docker
pip install docker-compose
```

- Change the content in /etc/docker/daemon.json to

```json
{
    "default-runtime": "nvidia",
    "runtimes": {
        "nvidia": {
            "path": "nvidia-container-runtime",
            "runtimeArgs": []
        }
    }
}
```

- Restart docker

```bash
sudo pkill -SIGHUP dockerd
```

For the above steps, you can also download this repository and under the repository directory, execute:

```bash
chmod +x docker_installation.sh
sudo ./docker_installation.sh
```

## Step 2. Create an AWS account and install `awscli`

You need to have an [AWS account](https://aws.amazon.com/) since the Docker images are stored in AWS ECR, but you won't be charged if you only use our images. You will be provided AWS access keys after you contact us.

- Install `awscli`

```bash
sudo apt update
sudo apt install awscli
```

- Configure `awscli` and use the provided AWS access keys after prompt

```bash
aws configure
```

- Docker login to AWS ECR

```bash
aws ecr get-login --no-include-email --region us-east-1 | sh
```

## Step 3. Run the Docker container

Copy the `docker-compose.yml` file to any place your want to run the container and type:

```bash
export ARCH=turing   # replace 'turing' with 'maxwell' if your GPU has architecture earier than turing
export NVIDIA_VISIBLE_DEVICES=0  # replace '0' with '1', '2'... if you want to run on the specific GPU device
docker-compose -f "docker-compose.yml" up -d
```

It could take several minitues to get ready for the first time but a few seconds after. Once the command returns no error, open the browser and type in `localhost:3000` with 'cphmd' as both username and password defaults. The web GUI is straightforward to use but if you have any questions, feel free to contact us.

*Note 1: you can change the default port number in the `docker-compose.yml` file by replacing the FIRST 3000 in "3000:3000" to your desired port.

*Note 2: you can use a pre-configured AWS AMI to run the Docker image if you don't have an Nvidia GPU. After lanuching an AWS EC2 GPU instance from the AMI, you can start from `aws configure` and follow the remaining. Use `ARCH=aws` to run.
