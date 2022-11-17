#!/bin/bash

# Update System
sudo yum update -y

# Install Docker
sudo yum install docker -y
sudo systemctl enable docker
sudo systemctl start docker
docker --version

# Setup SSH for Jenkins-Docker Config
sudo useradd -m dockeradmin
sudo echo -e "Secret123\nSecret123" | sudo passwd dockeradmin  
sudo usermod -aG docker dockeradmin
sudo sed -i '61 s/^.\{1\}//' /etc/ssh/sshd_config
sudo sed -i '62 s/^.\{1\}//' /etc/ssh/sshd_config
sudo sed -i '63 s/^/#/' /etc/ssh/sshd_config
sudo service sshd reload
sudo mkdir /opt/docker

<<EOF
sudo touch Dockerfile
sudo echo "FROM tomcat:latest" >> Dockerfile
sudo echo "RUN cp -R  /usr/local/tomcat/webapps.dist/*  /usr/local/tomcat/webapps" >> Dockerfile
sudo echo "COPY ./*.war /usr/local/tomcat/webapps" >> Dockerfile
docker build -t mytomcat .
docker run -d --name mytomcat-server -p 8080:8080 mytomcat
EOF


<<EOF
docker run -d --name tomcat-container -p 8080:8080 tomcat:latest
sudo docker exec -it tomcat-container /bin/bash
cp -a webapps.dist/. webapps/
EOF

<<EOF
sudo su -

# Update System
sudo yum update -y

# Install Java
sudo amazon-linux-extras install java-openjdk11 -y

# Install Tomcat
sudo wget https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.69/bin/apache-tomcat-9.0.69.tar.gz
sudo tar -xvzf apache-tomcat-9.0.69.tar.gz
sudo mv apache-tomcat-9.0.69 /opt/tomcat
sudo sed -i '21 s/^/<!--/' /opt/tomcat/webapps/host-manager/META-INF/context.xml
sudo sed -i '22 s/$/-->/' /opt/tomcat/webapps/host-manager/META-INF/context.xml
sudo sed -i '21 s/^/<!--/' /opt/tomcat/webapps/manager/META-INF/context.xml
sudo sed -i '22 s/$/-->/' /opt/tomcat/webapps/manager/META-INF/context.xml
sudo sed -i '55 a \\t<role rolename="manager-gui"/>' /opt/tomcat/conf/tomcat-users.xml 
sudo sed -i '56 a \\t<role rolename="manager-script"/>' /opt/tomcat/conf/tomcat-users.xml 
sudo sed -i '57 a \\t<role rolename="manager-jmx"/>' /opt/tomcat/conf/tomcat-users.xml 
sudo sed -i '58 a \\t<role rolename="manager-status"/>' /opt/tomcat/conf/tomcat-users.xml 
sudo sed -i '59 a \\t<user username="admin" password="admin" roles="manager-gui, manager-script, manager-jmx, manager-status"/>' /opt/tomcat/conf/tomcat-users.xml 
sudo sed -i '60 a \\t<user username="deployer" password="deployer" roles="manager-script"/>' /opt/tomcat/conf/tomcat-users.xml 
sudo sed -i '61 a \\t<user username="tomcat" password="s3cret" roles="manager-gui"/>' /opt/tomcat/conf/tomcat-users.xml 
/opt/tomcat/bin/startup.sh
EOF