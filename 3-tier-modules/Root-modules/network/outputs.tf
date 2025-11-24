output "vpc_id" {
  value = aws_vpc.project_vpc.id
}

output "public_subnet_ids" {
  value = aws_subnet.public_subnet[*].id
}

output "frontend_private_subnet_ids" {
  value = aws_subnet.frontend-private-subnet[*].id
}

output "backend_private_subnet_ids" {
  value = aws_subnet.backend-private-subnet[*].id
}

output "database_private_subnet_ids" {
  value = aws_subnet.database-private-subnet[*].id
}

output "vpc_cidr" {
  value = aws_vpc.project_vpc.cidr_block
}
