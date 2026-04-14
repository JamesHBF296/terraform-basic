data "aws_caller_identity" "current" {}

resource "aws_launch_template" "web_lt" {
  name_prefix   = "web-template-"
  image_id      = var.ami
  instance_type = var.instance_type

  vpc_security_group_ids = var.security_groups

  user_data = base64encode(var.user_data)

  iam_instance_profile {
    arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:instance-profile/WebServerS3Access"
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "terraform-web-server"
    }
  }
}