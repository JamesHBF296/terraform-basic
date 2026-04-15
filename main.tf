provider "aws" {
  region = "ap-southeast-5"

  default_tags {
    tags = {
      Terraform = "true"
      Project   = "Lab"
    }
  }
}

data "aws_availability_zones" "zone" {

}

data "aws_regions" "current" {

}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

module "vpc" {
  source             = "./modules/vpc_module"
  vpc_cidr           = "10.0.0.0/16"
  availability_zones = data.aws_availability_zones.zone.names
}

module "sg" {
  source = "./modules/sg_module"
  vpc_id = module.vpc.vpc_id
}

# module "web_server" {
#   source          = "./modules/ec2_module"
#   ami             = data.aws_ami.amazon_linux.id
#   instance_type   = "t3.micro"
#   subnet_id = module.vpc.public_subnet[0]
#   security_groups = [module.sg.public_sg_id]
#   key_name        = ${var.key_name}
#   user_data       = <<-EOF
#                       #!/bin/bash
#                       sudo yum update -y
#                       sudo yum install -y httpd
#                       sudo systemctl start httpd
#                       sudo systemctl enable httpd

#                       aws s3 sync s3://${var.s3_bucket_name}  /var/www/html/

#                       mv /var/www/html/james_hoh_portfolio.html /var/www/html/index.html

#                       chown -R apache:apache /var/www/html/
#                       EOF
#     tags = {
#     "name" = "web-server"
#   }

# }

module "alb" {
  source            = "./modules/alb_module"
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet
  lb_sg             = module.sg.public_sg_id
}

module "asg" {
  source           = "./modules/asg_module"
  desired_capacity = 4
  max_size         = 6
  min_size         = 2
  subnet_ids       = module.vpc.private_subnet
  security_groups  = [module.sg.private_sg_id]
  target_group_arn = module.alb.target_group_arn
  user_data        = <<-EOF
                      #!/bin/bash
                      sudo yum update -y
                      sudo yum install -y httpd
                      sudo systemctl start httpd
                      sudo systemctl enable httpd

                      aws s3 sync s3://${var.s3_bucket_name}  /var/www/html/

                      mv /var/www/html/james_hoh_portfolio.html /var/www/html/index.html

                      chown -R apache:apache /var/www/html/
                      EOF
  ami              = data.aws_ami.amazon_linux.id
  instance_type    = "t3.micro"
}