#######################################
# Launch Template for EC2 Instances
#######################################
resource "aws_launch_template" "web_lt" {
  name_prefix   = "web-lt-"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"

  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  user_data = base64encode(<<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "<h1>Hello from EC2 in ASG (Terraform)</h1>" > /var/www/html/index.html
              EOF
            )

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "web-instance"
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

#######################################
# Get Latest Amazon Linux 2 AMI
#######################################
data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["137112412989"] # Amazon official
}