resource "aws_launch_template" "web_lt" {
  name_prefix   = "web-template-"
  image_id      = var.ami
  instance_type = var.instance_type

  vpc_security_group_ids = var.security_groups

  user_data = base64encode(var.user_data)

  iam_instance_profile {
    name = var.iam_instance_profile_name
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "terraform-web-server"
    }
  }
}
