# Output values

# Attribute Reference - Public IP
output "ec2_instance_publicip" {
  description = "EC2 Instance Public IP"
  value = toset([
    for i in aws_instance.amzn-ec2-vm : i.public_ip
  ])
}


# Attribute Reference - Public DNS URL
output "ec2_publicdns" {
  description = "Public DNS URL of an EC2 Instance"
  value = toset([
    for i in aws_instance.amzn-ec2-vm : i.public_dns
  ])
}
