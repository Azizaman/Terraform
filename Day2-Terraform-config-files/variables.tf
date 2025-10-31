variable "ami_id" {
    description = "The AMI ID for the EC2 instance"
    type        = string
    default = "ami-0c55b159cbfafe1f0"
  
}

variable "instance_type" {
    description = "This is the variable for the instance type"
    type = string
    default = "t2.micro"
  
}