#create a Vpc
resource "aws_vpc" "vpc-practice" {
    cidr_block = "10.0.0.0/16"
    tags={
        Name="vpc-practice" 

    }
  
}

#create a subnet
resource "aws_subnet" "subnet1" {
    vpc_id = aws_vpc.vpc-practice.id
    cidr_block = "10.0.0.0/24"
    availability_zone = "us-east-1a"
    tags={
        Name="subnet-practice"
    }
  
}

#create an internet gateway
resource "aws_internet_gateway" "ig1" {
    vpc_id = aws_vpc.vpc-practice.id
    tags={
        Name="ig-practice"
    }
}
#create a route table
resource "aws_route_table" "route1" {
    vpc_id = aws_vpc.vpc-practice.id
    tags={
        Name="route-practice"
    }
    route{
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.ig1.id
    }  
}
#create subnet association
resource "aws_route_table_association" "rta1" {
    subnet_id = aws_subnet.subnet1.id
    route_table_id = aws_route_table.route1.id
}

#Create security group
resource "aws_security_group" "sg1"{
    name= "practice-sg"
    description = "This is the pratice security group"
    vpc_id = aws_vpc.vpc-practice.id
    tags = {
      Name="sg-practice"
    }
    ingress{
        description = "HTTP from VPC"
        from_port = 80
        to_port = 80
        protocol = "tcp"    
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress{
        description = "ssh"
        from_port =22
        to_port =22
        protocol = "ssh"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress{
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
#Create an EC2 instance
resource "aws_instance" "public" {
    ami = "ami-07860a2d7eb515d9a"
    instance_type = "t3.micro"
    subnet_id = aws_subnet.subnet1.id
    vpc_security_group_ids = [ aws_security_group.sg1.id ]
    associate_public_ip_address = true
    tags = {
      Name = "public-ec2"
    }
  
}
resource "aws_instance" "pvt" {
    ami = "ami-07860a2d7eb515d9a"
    instance_type = "t3.micro"
    subnet_id = aws_subnet.subnet1.id
    vpc_security_group_ids = [ aws_security_group.sg1.id ]
    
    tags = {
      Name = "pvt-ec2"
    }
}


resource "aws_s3_bucket" "bucketpractice" {
    bucket="dkfjnalksndlkansfnskfnkdsnfkjnsdfkjn"
  
}