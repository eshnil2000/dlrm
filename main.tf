# Specify the AWS provider version
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.29.0"
    }
  }
}

# Configure AWS provider
provider "aws" {
  region = "us-east-2"  # Specify your desired region
}

# Launch an EC2 instance
resource "aws_instance" "ec2_instance" {
  ami           = "ami-0e83be366243f524a"  # Ubuntu 22.04 LTS
  instance_type = "m5.16xlarge"  # Specify your desired instance type
  key_name      = "nilesh-dell-use2"  # Specify your key pair name

  vpc_security_group_ids = ["${aws_default_security_group.default.id}"]

  tags = {
    Name = "MyEC2Instance"
  }
  
  ebs_block_device {
    device_name = "/dev/sda1"
    volume_size = 400
  }

  # Remote provisioner to install Docker
  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt-get install -y docker.io wget sysstat && sudo sed -i 's#5-55/1 *#5-55/2 *#' /etc/cron.d/sysstat && sudo sed -i 's#false#true#' /etc/default/sysstat && sudo service sysstat restart",
      "sudo systemctl start docker",
      "wget https://raw.githubusercontent.com/eshnil2000/dlrm/main/Dockerfile",
      "git clone https://github.com/eshnil2000/dlrm && cd dlrm",
      "touch sarM.out",
      "touch sarC.out",
      "touch sarS.out",
      "sudo docker build -t dlrm-nilesh:latest .",
      "sar -S 30 240 >>sarS.out &",
      "sar -r 30 240 >>sarM.out &",
      "sar -P ALL 30 240 >>sarC.out &",
      "sudo docker run -d -v /home/ubuntu/dlrm/:/app dlrm-nilesh:latest"
    ]
  }
 
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("/home/cloudshell-user/keys/nilesh-dell-use2.pem")  # Specify the path to your private key
    host        = self.public_ip
  }
}

# Default VPC
resource "aws_default_vpc" "default" {}

# Default security group allowing SSH from anywhere
resource "aws_default_security_group" "default" {
  vpc_id = aws_default_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  
}
