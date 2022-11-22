# Infrastructure for Terraform-Ansible-Jenkins-Maven-Docker-Kubernetes Project

This is the infrastructure as code section for providing the AWS components needed for a DevOps project that is part of the Postgraduate Program at Caltech. The infrastructure includes three EC2 instances for a Jenkins server, an Ansible control node, and a Docker host machine. Security groups are also created in the process.

This repo https://github.com/lucaskienast/hello-world will then be used in a demo Jenkins build job where Maven will build a war file from it. Then the war file will be copied to an Ansible control node via ssh where a Docker image will be built from it on top of a Tomcat server before pushing it to Docker Hub, both of which will be done via an Ansible playbook. Finally, another separate VM that acts as the host of this webapp will be instructed via playbook on the Ansible control node to pull the created image and run a container on the VM using it.
