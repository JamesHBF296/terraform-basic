variable "instance_type" {
  default = "t3.micro"
}

variable "ami" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "security_groups" {
  type = list(string)
}

variable "key_name" {

}

variable "user_data" {
  default = ""
}

variable "tags" {
  type = map(string)
}

variable "iam_instance_profile_name" {
  type    = string
  default = null
}