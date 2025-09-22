variable "aws_region" {
  type    = string
  default = "eu-north-1" 
}

variable "project_name" {
  type    = string
  default = "ephemeral"
}

variable "instance_type" {
  type    = string
  default = "t3.small"
}

variable "pr_number" {
  type        = string
  description = "GitHub Pull Request number for ephemeral environment"
}
