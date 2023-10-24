resource "aws_launch_template" "blue" {
  name_prefix   = "blue-poc-lt"
  image_id      = var.blue_ami
  instance_type = "t2.micro"
  user_data = filebase64("${path.module}/example.sh")
}

resource "aws_autoscaling_group" "blue" {
  name                      = "blue-asg"
  max_size                  = 1
  min_size                  = 0
  health_check_grace_period = 60
  health_check_type         = "ELB"
  desired_capacity          = var.blue_desired_capacity
  force_delete              = true
  vpc_zone_identifier       = ["subnet-0164973e2348d5647"]


  launch_template {
    id      = aws_launch_template.blue.id
    version = aws_launch_template.blue.latest_version
  }

  target_group_arns = [aws_lb_target_group.blue.arn]

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 80
    }
  }
}

resource "aws_lb_target_group" "blue" {
  name     = "blue-tg-lb"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = "vpc-0d019cf014f209ac7"

  health_check {
    port     = 8080
    protocol = "HTTP"
    timeout  = 5
    interval = 10
  }
}