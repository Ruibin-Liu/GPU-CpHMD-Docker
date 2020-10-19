# iTitrate-Docker

iTitrate, developed by [ComputChem LLC](https://www.computchem.com/), is software created to accurately predict the pK<sub>a</sub>'s of titratable residues by simulating an acid-base titration experiment, i.e., letting a protein adjust its protonation and conformational states to solution pH, based on the GPU version of the Continuous Constant pH Molecular Dynamics (CpHMD) simulations in Amber software. It prepares CpHMD-ready PDB structures from protein crystal structures, stages CpHMD simulations, and generates pK<sub>a</sub> related results. Moreover, it provides a web GUI to control simulation parameters, monitor processes, and visualize results. Its Docker images privately stored on Amazon Web Services Elastic Container Registry (AWS ECR) which can run directly if `docker` and `docker-compose` are installed properly in your local machines with Nvidia GPU enabled. This repository, iTitrate-Docker, is for step-by-step instructions on how to use the Docker images.

## Step 0. Contact us

The Docker images are privately stored and only accessible with our permission. If you want to test or use our product, please contact us through our website [contact page](https://www.computchem.com/contact) or email support@computchem.com directly.

## Step 1. Launch LambdaLabs Instance

### Requirements: LambdaLabs account

### If you don't already have one create one here: [Create Lambda Account](https://lambdalabs.com/cloud/entrance)

### Link your SSH key and launch the 4x instance

![Launch Instance](/README_IMAGES/Launch_Instance.png)

### To connect to the instance simply copy paste the line under SSH Login into a terminal

![SSH](/README_IMAGES/SSH.png)

### Or use the web terminal

![web terminal](/README_IMAGES/web_terminal.png)

## Note: The rest of the steps are done on the launched instance, not your local computer

Install docker, docker-compose, and nvidia-docker by running the script provided in this repository.

  ```git clone https://github.com/Ruibin-Liu/iTitrate-Docker.git && /bin/bash iTitrate-Docker/docker_installation.sh```

It can take several minutes to finish the installation. After that,

  ```sudo reboot```

Login the instance again using SSH client or the web terminal.

## Step 2. Configure `awscli`

The Docker images are stored in AWS ECR. The `awscli` tool is to access those images through command line.

- Configure `awscli` and use the provided AWS access keys after prompt

  ```aws configure```

- Sync the credentials with docker to get access to our images

  ```aws ecr get-login --no-include-email --region us-east-1 | sh```

## Step 3. Run the Docker container

Example:

  ```export ARCH=turing && export NVIDIA_VISIBLE_DEVICES=0,1 && export NUM_NVIDIA_DEVICES=2 && docker-compose up -d```

![SSH](/README_IMAGES/done.png)

The setup of the instance might take several minutes, but relaunching it in the future will only take a couple seconds. Once launched, visit `localhost:3000` with `cphmd` as both username and password. The web GUI is straightforward to use, but if you have any questions, feel free to contact us.  

*Note 1: you can change the default port number in the `docker-compose.yml` file by replacing the FIRST 3000 in "3000:3000" to your desired port.

*Note 2: you can use a pre-configured AWS AMI to run the Docker image if you don't have an Nvidia GPU. After lanuching an AWS EC2 GPU instance from the AMI, you can start from `aws configure` and follow the remaining. Use `ARCH=aws` to run.
