# Create EC2 Instance - Amazon Linux
resource "aws_instance" "jenkins-ec2-vm" {
  ami                    = data.aws_ami.amzlinux.id
  instance_type          = var.instance_type
  count                  = 1
  key_name               = "terraform-key"
  vpc_security_group_ids = [aws_security_group.vpc-ssh.id, aws_security_group.vpc-web.id]
  tags = {
    "Name" = "jenkins-amz-linux-vm"
  }
}
