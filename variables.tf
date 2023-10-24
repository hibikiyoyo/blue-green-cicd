variable "blue_desired_capacity" {
  description = "number of instances in blue asg"
  type        = number
}

variable "blue_ami" {
  description = "ami of blue launch template"
  type        = string
}

variable "green_desired_capacity" {
  description = "number of instances in green asg"
  type        = number
}

variable "green_ami" {
  description = "ami of green launch template"
  type        = string
}

variable "traffic_distribution" {
  description = "Levels of traffic distribution"
  type        = string
}