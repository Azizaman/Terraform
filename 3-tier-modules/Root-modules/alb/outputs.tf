output "frontend_target_group_arn" {
  value = aws_lb_target_group.frontend-tg.arn
}

output "backend_target_group_arn" {
  value = aws_lb_target_group.backend_tg.arn
}

output "frontend_alb_dns_name" {
  value = aws_lb.frontend-alb.dns_name
}

output "backend_alb_dns_name" {
  value = aws_lb.backend-alb.dns_name
}

