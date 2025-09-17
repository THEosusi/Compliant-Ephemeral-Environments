variable "aws_region" {
  type    = string
  default = "eu-north-1"
}

variable "project_name" {
  type    = string
  default = "ephemeral-preinfra"
}

variable "s3_bucket_name" {
  type    = string
  default = "ephemeral-preinfra-tfstate-bucket"
}

variable "dynamodb_table_name" {
  type    = string
  default = "ephemeral-preinfra-tflocks"
}