#!/bin/bash

# Install Ansible
sudo yum update -y
sudo amazon-linux-extras install ansible2 -y
ansible --version

# Install Jenkins
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
amazon-linux-extras install epel
amazon-linux-extras install java-openjdk11
sudo yum install jenkins -y
sudo systemctl enable jenkins
sudo systemctl start jenkins
jenkins --version

# Install Git
sudo yum install git -y
git --version

# Install Maven
sudo wget https://dlcdn.apache.org/maven/maven-3/3.8.6/binaries/apache-maven-3.8.6-bin.tar.gz
sudo tar -xvzf apache-maven-3.8.6-bin.tar.gz
mv apache-maven-3.8.6 /opt/
sudo echo "export M2_HOME=/opt/apache-maven-3.8.6" >> /home/ec2-user/.bash_profile
sudo echo "export PATH=/opt/apache-maven-3.8.6/bin:$PATH" >> /home/ec2-user/.bash_profile
source /home/ec2-user/.bash_profile
mvn --version
