#!/bin/bash

# Update System
sudo yum update -y

# Update AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
sudo reboot

# Install kubectl
curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.24.7/2022-10-31/bin/linux/amd64/kubectl
chmod +x ./kubectl
mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$PATH:$HOME/bin
echo 'export PATH=$PATH:$HOME/bin' >> ~/.bashrc
# kubectl version --short --client

# Install eksctl
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin
# eksctl version

# Create cluster and nodes
eksctl create cluster --name webapp-cluster  \
--region us-east-1 \
--node-type t2.small
# kubectl get all
# eksctl delete cluster webapp-cluster --region us-east-1

# Deploy Nginx/Webapp Pods on k8
kubectl create deployment demo-nginx --image=nginx --replicas=2 --port=80
# kubectl deployment regapp --image=lucaskienast/regapp --replicas=2 --port=8080
# kubectl get all
# kubectl get pod

# Expose Deployment as a Service
kubectl expose deployment demo-nginx --port=80 --type=LoadBalancer
# kubectl expose deployment regapp --port=8080 --type=LoadBalancer
#kubectl get services -o wide