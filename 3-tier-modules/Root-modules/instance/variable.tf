variable "vpc_name" {
  type = string
  description = "vpc name to create the instance"
  
}
variable "bastion_instance_type" {
  type        = string
  description = "Instance type for the bastion instance"
}

variable "bastian_ami" {
  type        = string
  description = "AMI ID for the bastion instance"
}

variable "bastion_sg_id" {
  type        = string
  description = "Security group ID for the bastion instance"
}

variable "bastion_key_name" {
  type        = string
  description = "Key name for the bastion instance"
}

variable "bastian_subnet_id" {
  type        = string
  description = "Subnet ID for the bastion instance"
}

