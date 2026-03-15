#!/bin/bash

# Update packages
sudo apt update -y

# Install Docker
sudo apt install docker.io -y

cd /home/ubuntu

# Start and enable Docker
sudo systemctl start docker
sudo systemctl enable docker

# Add ubuntu user to docker group
sudo usermod -aG docker ubuntu

# Install dependencies
sudo apt install unzip curl -y

# Download AWS CLI v2
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"

# Unzip installer
unzip awscliv2.zip

# Install AWS CLI
sudo ./aws/install



# install ruby
sudo apt-get install ruby -y
# downloading codedeploy agent
wget https://aws-codedeploy-ap-south-1.s3.ap-south-1.amazonaws.com/latest/install
chmod +x ./install
sudo ./install auto
sudo service codedeploy-agent start
sudo systemctl enable codedeploy-agent


aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password-stdin 528043283929.dkr.ecr.ap-south-1.amazonaws.com
docker pull 528043283929.dkr.ecr.ap-south-1.amazonaws.com/churn-application-image:v1