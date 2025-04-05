# Security Group for the backend EC2 instance
resource "aws_security_group" "backend_sg" {
  name        = "backend-sg"
  description = "Security group for the backend application"

  # Ingress rule: Allow HTTP traffic on port 80
  ingress {
    description = "Allow HTTP traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Open to the internet (change in production)
  }

  # Ingress rule: Allow HTTPS traffic on port 443
  ingress {
    description = "Allow HTTPS traffic"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Ingress rule: Allow SSH access from your IP (change this for security)
  ingress {
    description = "Allow SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Restrict to your IP in production
  }

  # Egress rule: Allow all outbound traffic
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Key pair for the EC2 instance
resource "aws_key_pair" "backend_key_pair" {
  key_name = "backend-key"
  public_key = file("~/.ssh/id_ed25519.pub")
}

# EC2 Instance for the backend
resource "aws_instance" "backend" {
  ami             = "ami-0d866da98d63e2b42"  # Ubuntu 24.04 LTS (Noble)
  instance_type   = "t2.micro"
  key_name        = aws_key_pair.backend_key_pair.key_name  # The key pair declared above
  security_groups = [aws_security_group.backend_sg.name] # The security group declared above

  tags = {
    Name = "backend-server"
  }
}

output "ec2_public_ip" {
  value = aws_instance.backend.public_ip
  description = "The public of the EC2 instance"
}
