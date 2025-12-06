variable "domain_name" {
  type = string
}

variable "backend_alb_dns" {
  type = string
}

variable "backend_alb_zone_id" {
  type = string
}

variable "frontend_alb_dns" {
  type = string
}

variable "frontend_alb_zone_id" {
  type = string
}

variable "hosted_zone_id" {
  type = string
  description = "The hosted zone name"
}
