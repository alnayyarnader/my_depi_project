terraform {
  required_version = ">= 1.5.0"

  cloud {
    organization = "my-depi-project"

    workspaces {
      name = "depi-aws-ec2-instance"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "eu-north-1"
}

# 1. Create the Security Group via Terraform
resource "aws_security_group" "allow_ssh" {
  name        = "free-tier-ssh-sg"
  description = "Allow inbound SSH traffic"

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Free-Tier-SSH-SG"
  }
}

# Define the AMI dynamically
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# 2. Create the EC2 Instance and attach the Security Group
resource "aws_instance" "my_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.small"

  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  key_name               = "depi_locally_generated_ssh_public_key"

  credit_specification {
    cpu_credits = "standard"
  }

  root_block_device {
    volume_size           = 8
    volume_type           = "gp3"
    delete_on_termination = true
  }

  tags = {
    Name = "Free-Tier-Ubuntu-Server"
  }
}

# 3. OUTPUT THE IP FOR ANSIBLE:
output "public_ip" {
  value = aws_instance.my_server.public_ip
}
