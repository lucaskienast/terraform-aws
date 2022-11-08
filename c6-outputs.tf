# Output values

# Attribute Reference - Public IP
output "ec2_instance_publicip" {
  description = "EC2 Instance Public IP"
  value       = aws_instance.jenkins-ec2-vm.*.public_ip
}


# Attribute Reference - Public DNS URL
output "ec2_publicdns" {
  description = "Public DNS URL of an EC2 Instance"
  value       = aws_instance.jenkins-ec2-vm.*.public_dns
}
