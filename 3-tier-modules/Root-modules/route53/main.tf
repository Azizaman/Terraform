#using an already existing hosted zone and just creating the new records.



# resource "aws_route53_zone" "primary" {
#     name = var.domain_name
      
# }

resource "aws_route53_record" "api_record" {
    zone_id = var.hosted_zone_id
    name="api.${var.domain_name}"
    type="A"
    alias{  
    name                   = var.backend_alb_dns
    zone_id                = var.backend_alb_zone_id
    evaluate_target_health = true
    }
}

# Frontend Web → frontend ALB
resource "aws_route53_record" "app_record" {
  zone_id = var.hosted_zone_id
  name    = "app.${var.domain_name}"
  type    = "A"

  alias {
    name                   = var.frontend_alb_dns
    zone_id                = var.frontend_alb_zone_id
    evaluate_target_health = true
  }
}