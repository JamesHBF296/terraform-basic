resource "aws_subnet" "private_subnet" {
  for_each          = { for idx, az in var.availability_zones : az => idx }
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, each.value + 100)
  availability_zone = each.key


  tags = {
    Terraform = "true"
    Name      = "private-${each.key}"
  }
}


resource "aws_subnet" "public_subnet" {
  for_each                = { for idx, az in var.availability_zones : az => idx }
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, each.value)
  availability_zone       = each.key
  map_public_ip_on_launch = true
  tags = {
    Terraform = "true"
    Name      = "public-${each.key}"
  }
}