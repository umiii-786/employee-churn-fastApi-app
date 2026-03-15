#!/bin/bash

# Update packages
sudo apt update -y

# Install Docker
sudo apt install docker.io -y

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

# Verify installation
aws --version

aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password-stdin 528043283929.dkr.ecr.ap-south-1.amazonaws.com
docker pull 528043283929.dkr.ecr.ap-south-1.amazonaws.com/churn-application-image:v1