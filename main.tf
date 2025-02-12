terraform {
  backend "s3" {
    bucket         = "state-terraform-tf"
    key            = "terraform/terraform.tfstate"
    region         = "us-east-1"
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"  # Set AWS region to US East 1 (N. Virginia)
}

# Local variables block for configuration values
locals {
    aws_key = "SANJEEV_USEAST1_KEY"   # SSH key pair name for EC2 instance access
}

resource "aws_security_group" "allow_http" {
  count       = length(data.aws_security_groups.existing_sg.ids) > 0 ? 0 : 1
  name        = "allow_http"
  description = "Allow HTTP and SSH traffic"

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
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
}

# EC2 instance resource definition
resource "aws_instance" "my_server" {
   security_groups = [aws_security_group.allow_http.name]
   ami           = data.aws_ami.amazonlinux.id  # Use the AMI ID from the data source
   instance_type = var.instance_type            # Use the instance type from variables
   key_name      = "${local.aws_key}"          # Specify the SSH key pair name
  
   # Add tags to the EC2 instance for identification
   tags = {
     Name = "my ec2"
   }     

   user_data = file("wp_install.sh")             
}