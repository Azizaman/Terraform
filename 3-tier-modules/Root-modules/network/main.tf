# VPC, subnets, route tables, IGW, NAT GW

#1)VPC
resource "aws_vpc" "project_vpc" {
    cidr_block = var.vpc_cidr
    enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name=var.vpc_name
  }
}

#2)subnets
resource "aws_subnet" "public_subnet" {
  count = length(var.public_subnet_cidrs)
  vpc_id = aws_vpc.project_vpc.id
  cidr_block = element(var.public_subnet_cidrs, count.index)
  availability_zone = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true
  tags = {
    Name="${var.vpc_name}-public-subnet-${count.index + 1}"
  }
}

#frontend private subnets
resource "aws_subnet" "frontend-private-subnet" {
  count = length(var.frontend_private_subnet_cidrs)
  vpc_id = aws_vpc.project_vpc.id
  cidr_block = element(var.frontend_private_subnet_cidrs, count.index)
  availability_zone = element(var.availability_zones, count.index)
  tags = {
    Name="${var.vpc_name}-frontend-private-subnet-${count.index + 1}"
  }
}

#backend private subnets
resource "aws_subnet" "backend-private-subnet" {
  count = length(var.backend_private_subnet_cidrs)
  vpc_id = aws_vpc.project_vpc.id
  cidr_block = element(var.backend_private_subnet_cidrs, count.index)
  availability_zone = element(var.availability_zones, count.index)
  tags = {
    Name="${var.vpc_name}-backend-private-subnet-${count.index + 1}"
  }
}

#database private subnets
resource "aws_subnet" "database-private-subnet" {
  count = length(var.database_private_subnet_cidrs)
  vpc_id = aws_vpc.project_vpc.id
  cidr_block = element(var.database_private_subnet_cidrs, count.index)
  availability_zone = element(var.availability_zones, count.index)
  tags = {
    Name="${var.vpc_name}-database-private-subnet-${count.index + 1}"
  }
}

#internet gateway
resource "aws_internet_gateway" "project_ig" {
  vpc_id = aws_vpc.project_vpc.id
  tags = {
    Name="${var.vpc_name}-igw"
  }
}

#3)route tables
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.project_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.project_ig.id
  }
  tags = {
    Name="${var.vpc_name}-public-route-table"
  }
}

resource "aws_route_table_association" "public_route_table_association" {
  count = length(var.public_subnet_cidrs)
  subnet_id = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}

#elastic ip and nat gateway
resource "aws_eip" "project_eip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "project_nat" {
  allocation_id = aws_eip.project_eip.id
  subnet_id = aws_subnet.public_subnet[0].id
  tags = {
    Name = "${var.vpc_name}-nat-gateway"
  }
}

#private subnet route table association
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.project_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.project_nat.id
  }
  tags = {
    Name = "${var.vpc_name}-private-route-table"
  }
}

resource "aws_route_table_association" "frontend_private_rt_assoc" {
  count = length(var.frontend_private_subnet_cidrs)
  subnet_id = aws_subnet.frontend-private-subnet[count.index].id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "backend_private_rt_assoc" {
  count = length(var.backend_private_subnet_cidrs)
  subnet_id = aws_subnet.backend-private-subnet[count.index].id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "database_private_rt_assoc" {
  count = length(var.database_private_subnet_cidrs)
  subnet_id = aws_subnet.database-private-subnet[count.index].id
  route_table_id = aws_route_table.private_route_table.id
}




