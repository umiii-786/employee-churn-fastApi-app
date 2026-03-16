# Export Debian Frontend
export DEBIAN_FRONTEND=noninteractive

apt-get update -y
apt-get install -y docker.io

# start docker app
systemctl start docker
systemctl enable docker


# installing and downloading awscli
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/home/ubuntu/awscliv2.zip" 
unzip -o /home/ubuntu/awscliv2.zip -d /home/ubuntu/
 /home/ubuntu/aws/install 
aws --version

usermod -aG docker ubuntu

# Login to ECR
aws ecr get-login-password --region ap-south-1 \
| docker login --username AWS --password-stdin 528043283929.dkr.ecr.ap-south-1.amazonaws.com

# Pull docker image
docker pull 528043283929.dkr.ecr.ap-south-1.amazonaws.com/churn-application-image:v1