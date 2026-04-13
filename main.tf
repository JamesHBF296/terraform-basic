provider "aws" {
  region = "ap-southeast-5"
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
  source = "./modules/sg"
  vpc_id = module.vpc.vpc_id
}

module "web_server" {
  source          = "./modules/ec2"
  ami             = data.aws_ami.amazon_linux.id
  instance_type   = "t3.micro"
  subnet_id = module.vpc.public_subnet[0]
  security_groups = [module.sg.public_sg_id]
  key_name        = "NewKey"
  user_data       = <<-EOF
                      #!/bin/bash
                      dnf update -y
                      dnf install -y httpd

                      systemctl start httpd
                      systemctl enable httpd

                      echo "Hello from Terraform" > /var/www/html/index.html
                      EOF
    tags = {
    "name" = "web-server"
  }

}