terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "ephemeral-preinfra-tfstate-bucket"
    dynamodb_table = "ephemeral-preinfra-tflocks"
    encrypt        = true
  }
}

provider "aws" {
  region = var.aws_region
}

# AMI
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# Security Group
resource "aws_security_group" "no_inbound" {
  name        = "${var.project_name}-sg-${terraform.workspace}"
  description = "No inbound allowed (ephemeral test instance)"

  # checkov:skip=CKV_AWS_382: Ephemeral environment allowed outbound traffic for demonstration.
  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Web app port"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-sg-${terraform.workspace}"
    PR   = terraform.workspace
  }
}

# EC2 instance
resource "aws_instance" "ephemeral" {
  # checkov:skip=CKV2_AWS_41: Ephemeral environment does not need IAM role.
  ami                         = data.aws_ami.amazon_linux_2.id
  instance_type               = var.instance_type
  vpc_security_group_ids      = [aws_security_group.no_inbound.id]
  associate_public_ip_address = true # checkov:skip=CKV_AWS_88: Public IP needed for the demonstration.
  monitoring                  = true
  ebs_optimized               = true

  root_block_device {
    encrypted = true
  }


# launch application

  user_data = <<-EOF
  #!/bin/bash
  yum update -y
  yum install git python3 -y
  git clone https://github.com/THEosusi/Compliant-Ephemeral-Environments.git /home/ec2-user/app
  cd /home/ec2-user/app
  git fetch origin pull/${var.pr_number}/head:pr-${var.pr_number}
  git checkout pr-${var.pr_number}
  cd app
  python3 -m pip install flask
  nohup python3 app.py --host=0.0.0.0 --port=8080 &
  EOF

  tags = {
    Name = "${var.project_name}-ephemeral-${terraform.workspace}"
    Env  = "ephemeral"
    PR   = terraform.workspace
  }

  metadata_options {
    http_tokens   = "required"
    http_endpoint = "enabled"
  }
}