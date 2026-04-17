variable "s3_bucket_name" {
  type = string
}

variable "key_name" {
  type = string
}

variable "iam_instance_profile_name" {
  description = "The name of the IAM instance profile to use"
  type        = string
}