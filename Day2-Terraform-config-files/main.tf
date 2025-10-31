resource "aws_instance" "name" {
    instance_type = var.instance_type
    ami           = var.ami_id # Example AMI ID for Amazon Linux 2 in us-east-1
  
}