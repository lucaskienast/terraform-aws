#!/bin/bash

# Update System
sudo yum update -y

# Enable Password based Authentication
sudo sed -i '61 s/^.\{1\}//' /etc/ssh/sshd_config
sudo sed -i '62 s/^.\{1\}//' /etc/ssh/sshd_config
sudo sed -i '63 s/^/#/' /etc/ssh/sshd_config
sudo service sshd reload

# Install & setup Docker
sudo yum install docker -y
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker ec2-user
sudo mkdir /opt/docker
sudo mkdir /opt/k8
sudo chown ec2-user:ec2-user /opt/docker
sudo chown ec2-user:ec2-user /opt/k8

# Create Docker file for regapp
touch /opt/docker/Dockerfile
sudo echo "FROM tomcat:latest" >> /opt/docker/Dockerfile
sudo echo "RUN cp -R  /usr/local/tomcat/webapps.dist/*  /usr/local/tomcat/webapps" >> /opt/docker/Dockerfile
sudo echo "COPY ./*.war /usr/local/tomcat/webapps" >> /opt/docker/Dockerfile
sudo chmod 777 /var/run/docker.sock

# Setup user
sudo echo -e "Secret123\nSecret123" | sudo passwd ec2-user  
sudo usermod -aG docker ec2-user
sudo usermod -aG wheel ec2-user
sudo sed -i '110 s/^.//' /etc/sudoers

# Install & setup Ansible
sudo amazon-linux-extras install ansible2 -y
sudo chown ec2-user:ec2-user /etc/ansible
sudo chown ec2-user:ec2-user /etc/ansible/hosts
sudo echo "[ansible]" > /etc/ansible/hosts
sudo echo $(sudo hostname -I | awk '{print $1}') >> /etc/ansible/hosts
sudo echo "[dockerhost]" >> /etc/ansible/hosts
sudo echo $1 >> /etc/ansible/hosts
sudo echo "[k8host]" >> /etc/ansible/hosts
sudo echo $2 >> /etc/ansible/hosts

# Create ssh keys for admin user & copy to docker & k8 VMs
ssh-keygen -q -t rsa -N '' -f ~/.ssh/id_rsa <<<y >/dev/null 2>&1
sshpass -p "Secret123" ssh-copy-id -o StrictHostKeyChecking=no ec2-user@$(sudo hostname -I | awk '{print $1}')
sshpass -p "Secret123" ssh-copy-id -o StrictHostKeyChecking=no ec2-user@$1
sshpass -p "Secret123" ssh-copy-id -o StrictHostKeyChecking=no ec2-user@$2
# ansible all -m ping

# Create playbook to create Docker image from war file & push to Docker Hub
touch /opt/docker/create_image_regapp.yml
sudo echo "---" >> /opt/docker/create_image_regapp.yml
sudo echo "- hosts: ansible" >> /opt/docker/create_image_regapp.yml
sudo echo "  tasks:" >> /opt/docker/create_image_regapp.yml
sudo echo "  - name: create docker image" >> /opt/docker/create_image_regapp.yml
sudo echo "    command: docker build -t regapp:latest ." >> /opt/docker/create_image_regapp.yml
sudo echo "    args:" >> /opt/docker/create_image_regapp.yml
sudo echo "      chdir: /opt/docker" >> /opt/docker/create_image_regapp.yml
sudo echo "  - name: create tag to push image to Docker Hub" >> /opt/docker/create_image_regapp.yml
sudo echo "    command: docker tag regapp:latest lucaskienast/regapp:latest" >> /opt/docker/create_image_regapp.yml
sudo echo "  - name: push docker image" >> /opt/docker/create_image_regapp.yml
sudo echo "    command: docker push lucaskienast/regapp:latest" >> /opt/docker/create_image_regapp.yml
# ansible-playbook /opt/docker/create_image_regapp.yml

# Create playbook to create container on Docker host and pull image from Docker Hub
touch /opt/docker/docker_deploy_regapp.yml
sudo echo "---" >> /opt/docker/docker_deploy_regapp.yml
sudo echo "- hosts: dockerhost" >> /opt/docker/docker_deploy_regapp.yml
sudo echo "  tasks:" >> /opt/docker/docker_deploy_regapp.yml
sudo echo "  - name: stop existing container" >> /opt/docker/docker_deploy_regapp.yml
sudo echo "    command: docker stop regapp-server" >> /opt/docker/docker_deploy_regapp.yml
sudo echo "    ignore_errors: yes" >> /opt/docker/docker_deploy_regapp.yml
sudo echo "  - name: remove image" >> /opt/docker/docker_deploy_regapp.yml
sudo echo "    command: docker rmi -f lucaskienast/regapp:latest" >> /opt/docker/docker_deploy_regapp.yml
sudo echo "    ignore_errors: yes" >> /opt/docker/docker_deploy_regapp.yml
sudo echo "  - name: create container" >> /opt/docker/docker_deploy_regapp.yml
sudo echo "    command: docker run -d --rm --name regapp-server -p 8080:8080 lucaskienast/regapp:latest" >> /opt/docker/docker_deploy_regapp.yml
# ansible-playbook /opt/docker/deploy_regapp.yml

# Create playbook to create k8 deployment on k8 host
touch /opt/k8/kube_deploy_regapp.yml
sudo echo "---" >> /opt/k8/kube_deploy_regapp.yml
sudo echo "- hosts: k8host" >> /opt/k8/kube_deploy_regapp.yml
sudo echo "  tasks:" >> /opt/k8/kube_deploy_regapp.yml
sudo echo "  - name: deploy regapp on k8" >> /opt/k8/kube_deploy_regapp.yml
sudo echo "    command: kubectl apply -f /home/ec2-user/regapp-deployment.yml" >> /opt/k8/kube_deploy_regapp.yml
# ansible-playbook /opt/k8/kube_deploy_regapp.yml

# Create playbook to create k8 service on k8 host
touch /opt/k8/kube_service_regapp.yml
sudo echo "---" >> /opt/k8/kube_service_regapp.yml
sudo echo "- hosts: k8host" >> /opt/k8/kube_service_regapp.yml
sudo echo "  tasks:" >> /opt/k8/kube_service_regapp.yml
sudo echo "  - name: deploy regapp on k8" >> /opt/k8/kube_service_regapp.yml
sudo echo "    command: kubectl apply -f /home/ec2-user/regapp-service.yml" >> /opt/k8/kube_service_regapp.yml
sudo echo "  - name: update deployment with new pods if image updated in docker hub" >> /opt/k8/kube_service_regapp.yml
sudo echo "    command: kubectl rollout restart deployment.apps/lucas-regapp" >> /opt/k8/kube_service_regapp.yml
# ansible-playbook /opt/k8/kube_service_regapp.yml
