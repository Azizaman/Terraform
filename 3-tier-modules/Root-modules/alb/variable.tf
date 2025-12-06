variable "vpc_id" {
    type = string
    description = "The VPC ID"
}

variable "public_subnet_ids" {
    type = list(string)
    description = "List of public subnet IDs"
}

variable "private_subnet_ids" {
    type = list(string)
    description = "List of private subnet IDs"
}

variable "public_sg_id" {
    type = string
    description = "Public Security Group ID"
}

variable "backend_sg_id" {
    type = string
    description = "Backend Security Group ID"
}

variable "frontend_tg_name" {
    type = string
    description = "name of the frontend target group"
}

variable "frontend_tg_port" {
    type = number
    description = "port of the frontend target group"
}

variable "frontend_alb_name" {
    type = string
    description = "name of the frontend alb"
}

variable "backend_tg_name" {
    type = string
    description = "name of the backend target group"
}

variable "backend_tg_port" {
    type = number
    description = "port of the backend target group"
}

variable "backend_alb_name" {
    type = string
    description = "name of the backend alb"
}
variable "certificate_arn" {
    type = string
    description = "The ARN of the certificate"
}

