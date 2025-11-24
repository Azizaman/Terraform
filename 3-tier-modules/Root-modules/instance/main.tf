resource "aws_instance" "bastion_host" {
    ami = var.bastian_ami
    instance_type = var.bastion_instance_type
    vpc_security_group_ids = [var.bastion_sg_id]
    subnet_id = var.bastian_subnet_id
    key_name = var.bastion_key_name
    associate_public_ip_address = true

    tags = {
        Name = "${var.vpc_name}-bastion"
    }
  
}




