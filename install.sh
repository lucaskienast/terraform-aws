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
sudo yum install jenkins
sudo systemctl enable jenkins

# Install Git
sudo yum install git

# Install Maven
sudo wget https://dlcdn.apache.org/maven/maven-3/3.8.6/binaries/apache-maven-3.8.6-bin.tar.gz
sudo tar -xvzf apache-maven-3.8.6-bin.tar.gz
mv apache-maven-3.8.6 /opt/
M2_HOME='/opt/apache-maven-3.8.6'
PATH="$M2_HOME/bin:$PATH"
export PATH
source .bash_profile
mvn -v
