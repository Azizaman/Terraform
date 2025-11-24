variable "frontend_ami" {
  type        = string
  description = "AMI ID for the frontend instance"
}

variable "frontend_instance_type" {
  type        = string
  description = "Instance type for the frontend instance"
}

variable "backend_ami" {
  type        = string
  description = "AMI ID for the backend instance"
}

variable "backend_instance_type" {
  type        = string
  description = "Instance type for the backend instance"
}

variable "frontend_sg_id" {
  type        = string
  description = "Security group ID for the frontend instances"
}

variable "backend_sg_id" {
  type        = string
  description = "Security group ID for the backend instances"
}

variable "key_name" {
  type        = string
  description = "Key name for the instances"
}

variable "frontend_subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs for the frontend ASG"
}

variable "backend_subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs for the backend ASG"
}

variable "frontend_user_data" {
  type        = string
  description = "User data script for the frontend instance"
  default     = ""
}

variable "backend_user_data" {
  type        = string
  description = "User data script for the backend instance"
  default     = ""
}

variable "vpc_name" {
  type        = string
  description = "Name of the VPC"
}

variable "frontend_target_group_arn" {
  type        = string
  description = "ARN of the frontend target group"
  default     = ""
}

variable "backend_target_group_arn" {
  type        = string
  description = "ARN of the backend target group"
  default     = ""
}
