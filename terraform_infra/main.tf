provider "aws" {
  region = "us-west-2"  # Adjust your region accordingly
}

# Security group to allow SSH, HTTP, and HTTPS
resource "aws_security_group" "allow_ssh_http_https" {
  name        = "allow_ssh_http_https"
  description = "Allow SSH, HTTP, and HTTPS"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"

    cidr_blocks = ["0.0.0.0/0"]  # Allow SSH from anywhere
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow HTTP from anywhere
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow HTTPS from anywhere
  }
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow HTTP from anywhere
  }
 ingress {
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow HTTP from anywhere
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # Allow all outbound traffic
  }
}

# EC2 instance with custom AMI
resource "aws_instance" "my_ec2" {
  ami             = "ami-0b0f5251f6d5f92d3"  # Your custom AMI
  instance_type   = "t2.medium"                # Adjust based on requirements
  key_name        = "MyNewKeyPair"            # Your key pair
  security_groups = [aws_security_group.allow_ssh_http_https.name]

  # Adding user_data script to install Ansible on instance initialization (optional)
  user_data = <<-EOF
              #!/bin/bash
              apt-get update
              apt-get install -y ansible
              EOF

  tags = {
    Name = "SonarQube-Jenkins-Instance"
  }
}

# Output the public IP of the instance
output "instance_public_ip" {
  value = aws_instance.my_ec2.public_ip
}