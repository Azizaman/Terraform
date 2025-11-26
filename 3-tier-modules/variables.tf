variable "region" {
    type = string
    default = "us-east-1"
}

# Network Variables
variable "vpc_cidr" {
    type = string
    description = "The CIDR block for the VPC"
}

variable "public_subnet_cidrs" {
    type = list(string)
    description = "List of CIDR blocks for public subnets"
}

variable "availability_zones" {
    type = list(string)
    description = "List of availability zones"
}

variable "vpc_name" {
    type = string
    description = "Name of the VPC"
}

variable "frontend_private_subnet_cidrs" {
    type = list(string)
    description = "List of CIDR blocks for frontend private subnets"
}

variable "backend_private_subnet_cidrs" {
    type = list(string)
    description = "List of CIDR blocks for backend private subnets"
}

variable "database_private_subnet_cidrs" {
    type = list(string)
    description = "List of CIDR blocks for database private subnets"
}

# Security Variables
variable "ssh_port" {
    type = number
    default = 22
}

variable "http_port" {
    type = number
    default = 80
}

variable "https_port" {
    type = number
    default = 443
}

# Instance/Bastion Variables
variable "bastion_instance_type" {
    type = string
    description = "Instance type for the bastion host"
}


variable "key_name" {
    type = string
    description = "Key pair name for instances"
}

# RDS Variables
variable "rds_subnet_group_name" {
    type = string
    description = "Name of the RDS subnet group"
}

variable "db_name" {
    type = string
    description = "Name of the database"
}

variable "db_username" {
    type = string
    description = "Database username"
}

variable "db_password" {
    type = string
    description = "Database password"
    sensitive = true
}

# ALB Variables
variable "frontend_tg_name" {
    type = string
    description = "Name of the frontend target group"
}

variable "frontend_tg_port" {
    type = number
    description = "Port for the frontend target group"
}

variable "frontend_alb_name" {
    type = string
    description = "Name of the frontend ALB"
}

variable "backend_tg_name" {
    type = string
    description = "Name of the backend target group"
}

variable "backend_tg_port" {
    type = number
    description = "Port for the backend target group"
}

variable "backend_alb_name" {
    type = string
    description = "Name of the backend ALB"
}

# ASG Variables


variable "frontend_instance_type" {
    type = string
    description = "Instance type for frontend instances"
}

variable "frontend_user_data" {
    type = string
    description = "User data script for frontend instances"
    default = ""
}



variable "backend_instance_type" {
    type = string
    description = "Instance type for backend instances"
}

variable "backend_user_data" {
    type = string
    description = "User data script for backend instances"
    default = ""
}

variable "db_table_name" {
    type = string
    description = "Name of the database table"
}