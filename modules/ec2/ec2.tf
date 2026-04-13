

resource "aws_instance" "ec2_instance" {
  instance_type = var.instance_type
  ami = var.ami
  subnet_id = var.subnet_id
  vpc_security_group_ids = var.security_groups
  key_name = var.key_name
  user_data = var.user_data
  tags = var.tags
}

