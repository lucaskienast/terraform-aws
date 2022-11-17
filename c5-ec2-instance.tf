# Create EC2 Instance - Amazon Linux
resource "aws_instance" "amzn-ec2-vm" {
  ami                    = data.aws_ami.amzlinux.id
  instance_type          = var.instance_type
  for_each               = toset(var.ec2_instance_names)
  key_name               = "terraform-key"
  vpc_security_group_ids = [aws_security_group.vpc-ssh.id, aws_security_group.vpc-web.id]
  user_data              = file("install-${each.key}.sh")
  tags = {
    "Name" = "${each.key}-amzn-linux-vm"
  }
}
