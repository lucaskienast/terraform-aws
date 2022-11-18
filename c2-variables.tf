# Input variables
variable "aws_region" {
  description = "Region in which AWS Resources to be created"
  type        = string
}

variable "instance_type" {
  description = "EC2 Instance Type - Instance Sizing"
  type        = string
}

/*
variable "ec2_instance_names" {
  description = "EC2 Instance Names"
  type        = list(string)
  default     = ["ansible", "jenkins", "tomcat"]
}
*/
