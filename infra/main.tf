terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_security_group" "no_inbound" {
  name        = "${var.project_name}-sg"
  description = "No inbound allowed (ephemeral test instance)"

  # intentionally no ingress blocks

  # checkov:skip=CKV_AWS_382 reason="Ephemeral environment allowed outbound traffic for demonstration."
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
    Name = "${var.project_name}-sg"
  }
}

# EC2 instance, no public IP, no key_name -> cannot SSH from outside
resource "aws_instance" "ephemeral" {
  ami                         = data.aws_ami.amazon_linux_2.id
  instance_type               = var.instance_type
  vpc_security_group_ids      = [aws_security_group.no_inbound.id]
  associate_public_ip_address = true #checkov:skip=CKV_AWS_88: This is needed for the demonstration.
  monitoring                  = true  
  ebs_optimized               = true  

  root_block_device {               
    encrypted = true
  }



  user_data = <<-EOF
            #!/bin/bash
            yum update -y
            yum install git python3 -y
            git clone https://github.com/THEosusi/Compliant-Ephemeral-Environments.git /home/ec2-user/app
            cd /home/ec2-user/app/app
            python3 -m pip install flask
            nohup python3 app.py --host=0.0.0.0 --port=8080 &
            EOF

  tags = {
    Name = "${var.project_name}-ephemeral"
    Env  = "ephemeral"
  }

  metadata_options {
    http_tokens = "required"
    http_endpoint = "enabled"
  }
}