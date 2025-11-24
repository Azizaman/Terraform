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
    type=string
    description = "this is the name of the vpc"
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
