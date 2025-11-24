variable "rds_subnet_group_name" {
    type = string
    description = "subnet group name"
  
}
variable "rds_subnet_ids" {
    type = list(string)
    description = "subnet ids"
  
}

variable "db_name" {
    type = string
    description = "rds name here"
  
}

variable "username" {
    type = string
    description = "rds username here"
}

variable "password" {
    type = string
    description = "rds password here"
  
}

variable "vpc_security_group_ids" {
    type = string
    description = "security group id here"
  
}
