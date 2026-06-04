variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
  default     = "ami-00e801948462f718a"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.small"
}

variable "subnet_id" {
  description = "Subnet ID where the instance will be launched"
  type        = string
  default     = "subnet-07c58c00bfb20e8cc"
}

variable "instance_name" {
  description = "Name tag for the EC2 instance"
  type        = string
  default     = "myec2-instance"
}