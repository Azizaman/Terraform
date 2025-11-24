#target group for frontend alb
resource "aws_lb_target_group" "frontend-tg" {
    # name=var.frontend_tg_name
    port = var.frontend_tg_port
    protocol = "HTTP"
    vpc_id = var.vpc_id

    lifecycle {
      create_before_destroy = true
    }
    
}



resource "aws_lb" "frontend-alb" {
    name="frontend-alb"
    load_balancer_type = "application"
    subnets = var.public_subnet_ids
    security_groups = [var.public_sg_id]
    internal = false
    enable_deletion_protection = false
    tags = {
        Name="${var.frontend_alb_name}-lb"
    }  
    depends_on = [ aws_lb_target_group.frontend-tg ]

}   

#listener for frontend alb
resource "aws_lb_listener" "front_end_http" {
  load_balancer_arn = aws_lb.frontend-alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend-tg.arn
  }
  depends_on = [aws_lb_target_group.frontend-tg]
}


#tg for backend alb

# resource "aws_lb_target_group" "backend_tg" {
#   # name=var.backend_tg_name
#   port = var.backend_tg_port
#   protocol = "HTTP"
#   vpc_id = var.vpc_id

#   lifecycle {
#     create_before_destroy = true
#   }
  
# }


resource "aws_lb_target_group" "backend_tg" {
  port     = 3000
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    port = "3000"
    path = "/health"
    matcher = "200-399"
  }

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_lb" "backend-alb" {
  name = var.backend_alb_name
  load_balancer_type = "application"
  subnets = var.public_subnet_ids
  security_groups = [var.public_sg_id]
  internal = false
  enable_deletion_protection = false
  tags = {
    Name="${var.backend_alb_name}-lb"
  }  
  depends_on = [ aws_lb_target_group.backend_tg ]
}

resource "aws_lb_listener" "backend_http" {
  load_balancer_arn = aws_lb.backend-alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend_tg.arn
  }
  depends_on = [aws_lb_target_group.backend_tg]
}









