# SG for EC2 

resource "aws_security_group" "ec2_sg" {
  name   = "ec2-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# IAM Role 

resource "aws_iam_role" "ec2_role" {
  name = "ec2-ecr-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecr_read" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2-profile"
  role = aws_iam_role.ec2_role.name
}


# AMI image 

data "aws_ami" "amazon_linux" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}


# Launch Template 


resource "aws_launch_template" "app" {
  name_prefix   = "reliability-lt-"
  image_id      = data.aws_ami.amazon_linux.id # Amazon Linux 2 
  instance_type = "t3.micro"

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_profile.name
  }

  vpc_security_group_ids = [aws_security_group.ec2_sg.id]



  user_data = base64encode(<<EOF
#!/bin/bash
yum update -y
yum install -y docker
systemctl start docker

aws ecr get-login-password --region eu-west-3 | \
docker login --username AWS --password-stdin 413267728348.dkr.ecr.eu-west-3.amazonaws.com

docker run -d -p 8080:8080 \
413267728348.dkr.ecr.eu-west-3.amazonaws.com/infra-reliability-lab:latest
EOF
  )
}


# Auto Scaling Group 


resource "aws_autoscaling_group" "app" {
  desired_capacity = 1
  max_size         = 2
  min_size         = 1

  vpc_zone_identifier = [
    aws_subnet.public_a.id,
    aws_subnet.public_b.id
  ]

  target_group_arns = [aws_lb_target_group.app.arn]

  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }

  health_check_type         = "ELB"
  health_check_grace_period = 60
}