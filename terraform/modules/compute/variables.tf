variable "environment" {
  description = "Environment name (dev/staging)"
  type        = string
}

variable "project" {
  description = "Project name"
  type        = string
}

variable "subnet_id" {
  description = "Public subnet ID where EC2 will be deployed"
  type        = string
}

variable "security_group_id" {
  description = "Security Group ID for EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}