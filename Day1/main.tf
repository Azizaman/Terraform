resource "aws_vpc" "terafrom_vpc" {
    cidr_block = "10.0.0.0/16"
    tags = {
        Name = "terafrom_vpc_1"
    }
}

resource "aws_subnet" "name" {
    vpc_id = aws_vpc.terafrom_vpc.id
    cidr_block = "10.0.0.0/24"
    tags ={
        Name = "teraform_subnet_1"
    }
  
}