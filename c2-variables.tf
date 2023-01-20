# Input variables
variable "aws_region" {
  description = "Region in which AWS Resources to be created"
  type        = string
}

variable "instance_type" {
  description = "EC2 Instance Type - Instance Sizing"
  type        = string
}

variable "dockerhub_username" {
  description = "Username for DockerHub"
  type        = string
}

variable "dockerhub_password" {
  description = "Password for DockerHub"
  type        = string
}
