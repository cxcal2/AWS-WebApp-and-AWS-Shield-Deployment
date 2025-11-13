# Data source for latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# User data script to install Apache
locals {
  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y httpd
    systemctl start httpd
    systemctl enable httpd
    echo "<h1>Web Server $(hostname -f)</h1>" > /var/www/html/index.html
    EOF
}

# EC2 Instances
resource "aws_instance" "web" {
  count                  = length(aws_subnet.public)
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public[count.index].id
  vpc_security_group_ids = [aws_security_group.web.id]
  user_data              = base64encode(local.user_data)

  tags = {
    Name = "shield-web-${count.index + 1}"
  }
}

# Elastic IPs for instances
resource "aws_eip" "web" {
  count    = length(aws_instance.web)
  instance = aws_instance.web[count.index].id
  domain   = "vpc"

  tags = {
    Name = "shield-eip-${count.index + 1}"
  }

  depends_on = [aws_internet_gateway.main]
}