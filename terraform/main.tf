# 1. Create the Security Group via Terraform (100% Free)
resource "aws_security_group" "allow_ssh" {
  name        = "free-tier-ssh-sg"
  description = "Allow inbound SSH traffic"

  # Inbound Rule: Allow SSH on Port 22
  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Tip: Replace with ["YOUR_PUBLIC_IP/32"] for tighter security
  }

  # Outbound Rule: Allow the server to reach the internet (for apt update, git, etc.)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # "-1" means all protocols/ports
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Free-Tier-SSH-SG"
  }
}

# 2. Create the EC2 Instance and attach the Security Group above
resource "aws_instance" "my_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"

  # Attach the Security Group dynamically by referencing the resource above
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  # Optional: If you want to SSH in, add an SSH key pair name too
  key_name = "depi_locally_generated_ssh_public_key"

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
