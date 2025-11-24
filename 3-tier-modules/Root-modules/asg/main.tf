# Frontend Launch Template
resource "aws_launch_template" "frontend_lt" {
  name_prefix   = "${var.vpc_name}-frontend-lt-"
  image_id      = var.frontend_ami
  instance_type = var.frontend_instance_type
  key_name      = var.key_name

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [var.frontend_sg_id]
  }

  user_data = base64encode(var.frontend_user_data)

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.vpc_name}-frontend-instance"
    }
  }
}

# Frontend Auto Scaling Group
resource "aws_autoscaling_group" "frontend_asg" {
  name                = "${var.vpc_name}-frontend-asg"
  vpc_zone_identifier = var.frontend_subnet_ids
  max_size            = 3
  min_size            = 1
  desired_capacity    = 1

  target_group_arns = var.frontend_target_group_arn != "" ? [var.frontend_target_group_arn] : []

  launch_template {
    id      = aws_launch_template.frontend_lt.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.vpc_name}-frontend-asg"
    propagate_at_launch = true
  }
}

# Backend Launch Template
resource "aws_launch_template" "backend_lt" {
  name_prefix   = "${var.vpc_name}-backend-lt-"
  image_id      = var.backend_ami
  instance_type = var.backend_instance_type
  key_name      = var.key_name

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [var.backend_sg_id]
  }

  user_data = base64encode(var.backend_user_data)

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.vpc_name}-backend-instance"
    }
  }
}

# Backend Auto Scaling Group
resource "aws_autoscaling_group" "backend_asg" {
  name                = "${var.vpc_name}-backend-asg"
  vpc_zone_identifier = var.backend_subnet_ids
  max_size            = 3
  min_size            = 1
  desired_capacity    = 1

  target_group_arns = var.backend_target_group_arn != "" ? [var.backend_target_group_arn] : []

  launch_template {
    id      = aws_launch_template.backend_lt.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.vpc_name}-backend-asg"
    propagate_at_launch = true
  }
}