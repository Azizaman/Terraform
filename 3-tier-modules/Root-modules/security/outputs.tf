output "frontend_sg_id" {
  value = aws_security_group.frontend-sg.id
}

output "backend_sg_id" {
  value = aws_security_group.backend-sg.id
}

output "database_sg_id" {
  value = aws_security_group.database-sg.id
}

output "public_sg_id" {
  value = aws_security_group.public-sg.id
}
