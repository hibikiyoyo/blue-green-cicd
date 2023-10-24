output "lb_dns_name" {
  value = aws_lb.this.dns_name
}

output "blue_desired_capacity" {
  value = aws_autoscaling_group.blue.desired_capacity
}

output "green_desired_capacity" {
  value = aws_autoscaling_group.green.desired_capacity
}

output "blue_lt" {
  value = aws_launch_template.blue.id
}

output "green_lt" {
  value = aws_launch_template.green.id
}