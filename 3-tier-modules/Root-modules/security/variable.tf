variable "vpc_id" {
    type = string
    description = "The VPC ID"
}

variable "ssh_port" {
    type = number
    description = "The port for SSH"
    default = 22
}
variable "http_port" {
    type = number
    description = "The port for HTTP"
    default = 80
}
variable "https_port" {
    type = number
    description = "The port for HTTPS"
    default = 443
}