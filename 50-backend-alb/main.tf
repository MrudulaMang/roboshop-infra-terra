# session 42

resource "aws_lb" "backend_alb" {
  name               = "${var.project}-${var.environment}" # roboshop-dev
  internal           = true
  load_balancer_type = "application"
  security_groups    = [local.backend_alb_sg_id]
  subnets            = local.private_subnet_ids

  # keeping it as false, just to delete using terraform while practice
  enable_deletion_protection = false

  tags = merge(
    {
        Name = "${var.project}-${var.environment}"
    },
    local.common_tags
  )
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.backend_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/html"
      message_body = "<h1>Hi, I am from HTTP Backend ALB</h1>"
      status_code  = "200"
    }
  }
}

resource "aws_route53_record" "www" {
  zone_id = var.zone_id
  name    = "*.backend-alb-${var.environment}.${var.domain_name}"
  type    = "A"
  
  # load balancer details
  alias {
    name                   = aws_lb.backend_alb.dns_name
    zone_id                = aws_lb.backend_alb.zone_id
    evaluate_target_health = true
  }
}
#-----------------------------------------------------------
  #LB rule should choose atleast two azs
  #cannot access port no 22 for lb as it is completely managed by aws
# host path retailbanking.icicibank.com
# main host icicibank.com 
# context path icicibank.com/retailbanking

#listener rules--> upto 50k
  # resolves lowest to highest, if nothing gets evaluated default will be taken
  # 503 service not available. when lb cant reach service/instance